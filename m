Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752782Ab3AVVvI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 16:51:08 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:50646 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751490Ab3AVVvF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 16:51:05 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Borislav Petkov <bp@alien8.de>
Cc: Matthew Garrett <matthew.garrett@nebula.com>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org,
        Leonid Isaev <lisaev@umail.iu.edu>
Subject: Re: [PATCH] Add module aliases for acpi-cpufreq
Date: Tue, 22 Jan 2013 22:57:05 +0100
Message-ID: <3231405.HBLxbMEfo4@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc4; KDE/4.9.5; x86_64; ; )
In-Reply-To: <20130122173835.GB6431@pd.tnic>
References: <1358872944-7676-1-git-send-email-matthew.garrett@nebula.com> <20130122173835.GB6431@pd.tnic>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, January 22, 2013 06:38:36 PM Borislav Petkov wrote:
> On Tue, Jan 22, 2013 at 11:42:24AM -0500, Matthew Garrett wrote:
> > The acpi core will call request_module("acpi-cpufreq") on subsystem init,
> > but this will fail if the module isn't available at that stage of boot.
> > Add some module aliases to ensure that udev can load the module on Intel
> > and AMD systems with the appropriate feature bits - I /think/ that this
> > will also work on VIA systems, but haven't verified that.
> > 
> > Signed-off-by: Matthew Garrett <matthew.garrett@nebula.com>
> 
> Let's add some more tags:
> 
> Link: http://lkml.kernel.org/r/1448223.sdUJnNSRz4@vostro.rjw.lan
> Tested-by: Leonid Isaev <lisaev@umail.iu.edu>
> Acked-by: Borislav Petkov <bp@suse.de>
> 
> Rafael, this is all yours. :-)

Thanks!

Do I think correctly that it should go into 3.7.y too?

Rafael


> > ---
> >  drivers/cpufreq/acpi-cpufreq.c | 7 +++++++
> >  1 file changed, 7 insertions(+)
> > 
> > diff --git a/drivers/cpufreq/acpi-cpufreq.c b/drivers/cpufreq/acpi-cpufreq.c
> > index 0d048f6..7b0d49d 100644
> > --- a/drivers/cpufreq/acpi-cpufreq.c
> > +++ b/drivers/cpufreq/acpi-cpufreq.c
> > @@ -1030,4 +1030,11 @@ MODULE_PARM_DESC(acpi_pstate_strict,
> >  late_initcall(acpi_cpufreq_init);
> >  module_exit(acpi_cpufreq_exit);
> >  
> > +static const struct x86_cpu_id acpi_cpufreq_ids[] = {
> > +	X86_FEATURE_MATCH(X86_FEATURE_ACPI),
> > +	X86_FEATURE_MATCH(X86_FEATURE_HW_PSTATE),
> > +	{}
> > +};
> > +MODULE_DEVICE_TABLE(x86cpu, acpi_cpufreq_ids);
> > +
> >  MODULE_ALIAS("acpi");
> 
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
