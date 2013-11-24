Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756422Ab3KXKkh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Nov 2013 05:40:37 -0500
Received: from mail-qe0-f41.google.com ([209.85.128.41]:32962 "EHLO
	mail-qe0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751810Ab3KXKkf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Nov 2013 05:40:35 -0500
MIME-Version: 1.0
In-Reply-To: <BLU177-W2447DFF42B4252458F6F80C3E20@phx.gbl>
References: <BLU177-W2447DFF42B4252458F6F80C3E20@phx.gbl>
Date: Sun, 24 Nov 2013 10:40:34 +0000
X-Google-Sender-Auth: BQUU8Gp3S5ejehpmpPYuiv9lfSg
Message-ID: <CAPweEDyvOk0GdiyiyA1OyhZHVnTGZEXvysCbBfp4CxYXA2BT6A@mail.gmail.com>
Subject: Re: On EOMA-68 patent licensing...
From: Luke Kenneth Casson Leighton <lkcl@lkcl.net>
To: Yuhong Bao <yuhongbao_386@hotmail.com>
Cc: "mjg59@srcf.ucam.org" <mjg59@srcf.ucam.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 24, 2013 at 3:35 AM, Yuhong Bao <yuhongbao_386@hotmail.com> wrote:
> I read this: http://hardware.slashdot.org/comments.pl?sid=3102545&cid=41270883
> Makes me wonder what would happen if something similar was tried with EFI or ACPI?

 the EOMA68 project is unique in that it is a mass-volume *modular*
architecture [*1], and it is (until intel and amd pull their fingers
out their arses and properly get below the 2W barrier) using the
so-called "embedded" SoCs - you know, the ones that don't have a BIOS?
 the ones that are causing linus to throw toys-out-of-prams?  what's
the name again... oh yes - ARM!  yes, that's the ones, silly me how
could i forget.

 so with no BIOS a degree of cooperation between hardware and software
on *both* sides of the interfaces is therefore... critical.

 an example of the closest corresponding danger that's related to
single-board monolithic designs is CONFIG_SYS_GPIO.  access to GPIO is
typically disabled by default in distro-released kernels (e.g. debian)
and even there if you look at e.g. the CS5535 GPIO module it's
hard-coded into the kernel source that "unsafe" GPIO cannot be
accessed even if it's requested.

 in other words, what would normally be dealt with either by the
proprietary vendor's BIOS on a single-board design plus a tiiiny bit
of help from some linux kernel source, suddenly now that's all out the
window.

 the next closest corresponding danger is x86 BIOSes (coreboot,
tinybios) etc. which is where dangers related to EFI and ACPI would
properly come into play and that's not the linux kernel's problem,
it's coreboot, tinybios, phoenix bios etc. etc.'s BIOS's problem, so
i'd kiinda say it's out of scope.  unless anyone else knows different?

l.

[*1] designed to solve the toys-out-of-pram issue by reducing the
Linux Kernel Hell surrounding embedded products from an "N product
design types times M processors" problem to a manageable "N designs
*plus* M processor-modules" arena.
