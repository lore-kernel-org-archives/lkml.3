Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757095Ab3ANQzn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 11:55:43 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:58782 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757002Ab3ANQzl convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:8:1>);
	Mon, 14 Jan 2013 11:55:41 -0500
Message-Id: <50F4469802000078000B57EB@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.1 
Date: Mon, 14 Jan 2013 16:55:36 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "Borislav Petkov" <bp@alien8.de>, "Andre Przywara" <andre@andrep.de>,
        "Stefan Bader" <stefan.bader@canonical.com>
Cc: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>,
        "Matthew Garrett" <mjg@redhat.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] kernel 3.7+ cpufreq regression on AMD system
 running as dom0
References: <50F42B3E.7090602@canonical.com>
 <20130114163445.GA4867@liondog.tnic>
In-Reply-To: <20130114163445.GA4867@liondog.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 14.01.13 at 17:34, Borislav Petkov <bp@alien8.de> wrote:
> On Mon, Jan 14, 2013 at 04:58:54PM +0100, Stefan Bader wrote:
>> --- a/drivers/acpi/processor_perflib.c
>> +++ b/drivers/acpi/processor_perflib.c
>> @@ -340,6 +340,9 @@ static void amd_fixup_frequency(struct acpi_processor_px 
> *px
>>         if ((boot_cpu_data.x86 == 0x10 && boot_cpu_data.x86_model < 10)
>>             || boot_cpu_data.x86 == 0x11) {
>>                 rdmsr(MSR_AMD_PSTATE_DEF_BASE + index, lo, hi);
>> +               /* Bit 63 indicates whether contents are valid */
>> +               if (!(hi & 0x8000000))
>> +                       return;
> 
> I don't think that's the right change - this is fixing baremetal so that
> it works on xen. And besides, this code was in powernow-k8 before so I'm
> wondering why did it work then.

Because the driver doesn't get loaded in that case?

Jan

