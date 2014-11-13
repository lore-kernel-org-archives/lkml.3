Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932708AbaKMLPx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 06:15:53 -0500
Received: from mout.kundenserver.de ([212.227.126.131]:58674 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932364AbaKMLPv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 06:15:51 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Peter Griffin <peter.griffin@linaro.org>, linux-kernel@vger.kernel.org,
        maxime.coquelin@st.com, srinivas.kandagatla@gmail.com,
        patrice.chotard@st.com, devicetree@vger.kernel.org,
        lee.jones@linaro.org
Subject: Re: [PATCH v2 13/14] ARM: STi: DT: STiH410: Add usb2 picophy dt nodes
Date: Thu, 13 Nov 2014 12:15:35 +0100
Message-ID: <3348806.YN8XP4V4uc@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1415876417-28728-14-git-send-email-peter.griffin@linaro.org>
References: <1415876417-28728-1-git-send-email-peter.griffin@linaro.org> <1415876417-28728-14-git-send-email-peter.griffin@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:UJKRHJnSg5XxoC7eDXP8OpubSeLQewfMgXGujxKFhlV
 4wo/RTBerr15qxLECqaM+YS87WrdPGnJgn64Cfdq52W/Z7DxD0
 cEAuUM8hP1SbVV6AZWosYV5oq3aM1ZcfU3E35LB0s/vVT9vexM
 2feMW694u75VgvukWmzO0n1K+0/iLONCBD+2W4lLQDbxg0XR8B
 pxpaXWKLBcynTkYPqHtIrI4yn+hMksCqlMH5Hfz8auGVG2f51c
 xW4gQuEFmyVbgBw7KIPea2jJnmMv5RgsdQTthhRlFhKwZem7tO
 412yCom+bJUCbjPCBOZ5rHEONRVablA8U8E+fdwxKDlED7q/g7
 YcUzPB+kgxA4X4TVAeEc=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 13 November 2014 11:00:16 Peter Griffin wrote:
> +       soc {
> +               usb2_picophy0: usbpicophy@0 {
> +                       compatible = "st,stih407-usb2-phy";
> +                       reg = <0xf8 0x04>,      /* syscfg 5062 */
> +                             <0xf4 0x04>;      /* syscfg 5061 */
> 

I think the node name for the phy should be "phy@f8" instead of usbpicophy@0
by common convention. I notice that there are some existing instances of
this, you can probably change them as well. Linux doesn't normally care
about the node names.

It also seems that you have put the node in the wrong place, as the reg
property apparently refers to a different address space. Did you mean
to put this under the syscfg_core node?

	Arnd
