Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758320Ab3EHSg3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 14:36:29 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:61325 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758256Ab3EHSg1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 14:36:27 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Nicolas Pitre <nicolas.pitre@linaro.org>
Subject: Re: [RFC 1/8] serial:st-asc: Add ST ASC driver.
Date: Wed, 8 May 2013 20:35:56 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-18-generic; KDE/4.3.2; x86_64; ; )
Cc: Greg KH <gregkh@linuxfoundation.org>,
        "Jean-Christophe PLAGNIOL-VILLARD" <plagnioj@jcrosoft.com>,
        Srinivas KANDAGATLA <srinivas.kandagatla@st.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Will Deacon <will.deacon@arm.com>, jslaby@suse.cz,
        Russell King <linux@arm.linux.org.uk>,
        Samuel Ortiz <sameo@linux.intel.com>, linux-doc@vger.kernel.org,
        Stephen Gallimore <stephen.gallimore@st.com>,
        linux-serial@vger.kernel.org, Jason Cooper <jason@lakedaemon.net>,
        devicetree-discuss@lists.ozlabs.org,
        Rob Herring <rob.herring@calxeda.com>,
        Stuart Menefy <stuart.menefy@st.com>,
        Stephen Warren <swarren@nvidia.com>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org
References: <1368022187-1633-1-git-send-email-srinivas.kandagatla@st.com> <201305081831.48566.arnd@arndb.de> <alpine.LFD.2.03.1305081239260.13109@syhkavp.arg>
In-Reply-To: <alpine.LFD.2.03.1305081239260.13109@syhkavp.arg>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201305082035.57154.arnd@arndb.de>
X-Provags-ID: V02:K0:hBcqdQFg2QxCo/QuU/YKiMBZliRtEy+yItOYB1M/5qN
 gWJd5BJj14fAklxBtxgCEzE9r1QQ9uI+0yixNlbGQ30sCu01Ut
 ee0mEF0d1KZ/2YQQLsR05J6bbOdockmDYtPZhFuiFeqbEAX+S3
 ACvAoxoa3Fcpx9qBm4fNdrJTnqvSISiFKCUJTAOML6YP0eriOG
 wAJKBoGqaSCVbW6p8UNS2QKgKCSfuVwNVBS9btItlQ3If4a4JU
 1S9MbnXupMzAtLZMpZbLSIoeiDPwhEjnM+r7huxjrVt8XYfBE1
 HxNpIRo8aDHEJLzV26oGEM//n2lMor/l3D3xCLMQVOwQvRElEp
 +Mpu0dlrRg4xkN08mHjA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 08 May 2013, Nicolas Pitre wrote:
> I tried to fix this up over 10 years ago.  RMK tried as well. This 
> failed because X86 people insisted on always having COM1 as /dev/ttyS0, 
> COM3 as /dev/ttyS2 and so on, even when some of them weren't present.
> 
> A common and dynamic namespace eventually succeeded for hard disks.
> Maybe people are ready to accept it for serial ports as well now?

Unfortunately it only worked for hard disks because the old name
space was abandoned entirely. It also caused a lot of surprises
for people upgrading their kernels, which is something we probably
don't want to repeat.

Now we could add a new dynamic registration facility to the tty
layer for drivers that don't already have a name and dev_t
associated with the driver, and then use it for all new drivers
as well as those that intentionally want to convert.

With DT aliases, we already have a way to enumerate serial ports
across device drivers, so if we are going to do something new,
we should make sure it works with the numbers defined there.

	Arnd
