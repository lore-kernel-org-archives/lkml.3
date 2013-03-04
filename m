Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757264Ab3CDMzx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 07:55:53 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:54405 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756448Ab3CDMzw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 07:55:52 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Ley Foon Tan <lftan@altera.com>
Subject: Re: [PATCH 1/1] drivers/misc: Add Altera System ID driver
Date: Mon, 4 Mar 2013 12:55:41 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-8-generic; KDE/4.3.2; x86_64; ; )
Cc: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Rob Landley <rob@landley.net>, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
References: <1362366697-2768-1-git-send-email-lftan@altera.com> <20130304034430.GA1274@kroah.com> <1362390111.3066.11.camel@leyfoon-vm>
In-Reply-To: <1362390111.3066.11.camel@leyfoon-vm>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201303041255.42142.arnd@arndb.de>
X-Provags-ID: V02:K0:rHgmNTLYxufgbJbpVUl+4k5QqSzVi0L9nzNwewqc4Wl
 6ZrIDCqecmf9pfI+VD6eYL5Uyyy2SWWvRm4+sQNOnvHNrju392
 JGO3OsOuMKeLABB++z2nmey7+bsjVdzZWBHa8K36OuYzBlgbOv
 D7AGCf2rO2njnMCloJ0OceMcv34YAmURSWSda//7rJe3Mm4xDA
 aD5W74yDECZmy2sppAbxZf2pYQPopjiobJTpuu40o7okwX2AMQ
 vHyyuB3jkqUALKxs5tZiLzWFDfYg1Ne3NH1NpIGMJnnqtcDSlL
 fbAq8vWvhmCw+XeeK2fMpq/DauRReYNmHCfS28gfRPi4K7fhAh
 xMPxbkqWI7XuY59OyRNU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 04 March 2013, Ley Foon Tan wrote:
> This IP core is not in the SoC. This core is in the FPGA and can be
> accessed by the Nios II processor or accessed by SOCFPGA processor (ARM
> based) via its interface to FPGA. Due to this, I think it shouldn't use
> infrastructure in drivers/base/soc.c.
> What do you think?

The sysid component gives a version for the entire FPGA part and all
components inside it, right?

I think you should use the drivers/base/soc.c interface to describe the
SOCFPGA SoC components as well as the actual FPGA. You basically
end up having one device node that acts as the parent for the SoC
components, and a way to retrieve version information about it.

Depending on how it fits the actual hardware layout more closely,
you could have one node as the parent for all devices, or the
FPGA SoC node as a child of the main one, or two SoC nodes side by
side from the top-level.

	Arnd
