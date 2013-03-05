Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753671Ab3CEV7n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 16:59:43 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:62450 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752838Ab3CEV7l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 16:59:41 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Ley Foon Tan <lftan@altera.com>
Subject: Re: [PATCH 1/1] drivers/misc: Add Altera System ID driver
Date: Tue, 5 Mar 2013 21:59:36 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-8-generic; KDE/4.3.2; x86_64; ; )
Cc: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Rob Landley <rob@landley.net>, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
References: <1362366697-2768-1-git-send-email-lftan@altera.com> <201303041255.42142.arnd@arndb.de> <1362481947.2293.11.camel@leyfoon-vm>
In-Reply-To: <1362481947.2293.11.camel@leyfoon-vm>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201303052159.36531.arnd@arndb.de>
X-Provags-ID: V02:K0:LHZiDH24TRdcGyfwRzzcbEnG1UR1vJZ8gUi8OYGnHkU
 RUZcy+LYFQKpCdSB9vcUwqUI/C+HjapMAfetYM4vkOm0ltuI6r
 Ah/z6FaeigjWurq5TBu2vOKps1LU9dS8UYYOC3k60cTEHm4ah5
 MaKTpubaHU5UU6EHnC+ZUc66xX1bP9a+k7CQ4FbE3VmxABzgSh
 Xv2/eGn90sjIIOhRYcS8/h3NSLxGvaQvzk1eWfgwL20rbJcfyN
 Yx00z1qrEDUtgDXCSlYVQaMZR9i4VdCB+4gm+OBFU37dnPuusy
 SvarLco+ovUPK/qfW5mO3XmCxinh5PnbuqDlCb6rDLFsGWSVu6
 y2sYFl+Kn4Ycy/0Y4yp8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 05 March 2013, Ley Foon Tan wrote:
> The sysid give the unique system ID and system generation timestamp of
> the system.
> 
> CASE 1:
> SOCFPGA SoC + Sysid component in FPGA
> 
> CASE 2
> Nios II soft core CPU + Sysid  (All in FPGA and no SoC is involved)
> 
> From example use cases above, Case 2 doesn't involve SoC component. 
> To support both cases, do you think drivers/base/soc.c is still
> suitable?

Yes, I think so. I would consider the second case still a SoC, because
you have a single chip that contains the CPU and peripherals. From
the OS point of view, it does not matter that they are in an FPGA.

	Arnd
