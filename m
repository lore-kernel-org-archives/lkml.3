Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752388Ab3FZStn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 14:49:43 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:52311 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752145Ab3FZStl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 14:49:41 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jan Beulich <JBeulich@suse.com>
Cc: Ben Guthro <benjamin.guthro@citrix.com>,
        Bob Moore <robert.moore@intel.com>, xen-devel@lists.xen.org,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/3] acpi: Call acpi_os_prepare_sleep hook in reduced hardware sleep path
Date: Wed, 26 Jun 2013 20:59:10 +0200
Message-ID: <4869705.1kam6LnVRF@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0-rc5+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <51CB28D102000078000E0DF8@nat28.tlf.novell.com>
References: <1372255575-29567-1-git-send-email-benjamin.guthro@citrix.com> <CAOvdn6V0TJRF6r_2=CETPsiqawMpKxos+rCn8+aQ+SqU2p1WiQ@mail.gmail.com> <51CB28D102000078000E0DF8@nat28.tlf.novell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, June 26, 2013 04:45:53 PM Jan Beulich wrote:
> >>> On 26.06.13 at 17:03, Ben Guthro <benjamin.guthro@citrix.com> wrote:
> > On Wed, Jun 26, 2013 at 10:41 AM, Jan Beulich <JBeulich@suse.com> wrote:
> >>>>> On 26.06.13 at 16:06, Ben Guthro <benjamin.guthro@citrix.com> wrote:
> >>> In version 3.4 acpi_os_prepare_sleep() got introduced in parallel with
> >>> reduced hardware sleep support, and the two changes didn't get
> >>> synchronized: The new code doesn't call the hook function (if so
> >>> requested). Fix this, requiring a parameter to be added to the
> >>> hook function to distinguish "extended" from "legacy" sleep.
> >>>
> >>> Signed-off-by: Ben Guthro <benjamin.guthro@citrix.com>
> >>> Signed-off-by: Jan Beulich <jbeulich@suse.com>
> >>
> >> I think these are intended to reflect the flow of things, so
> >> should be reversed (also in the other patches).
> >>
> >>> --- a/drivers/acpi/acpica/hwesleep.c
> >>> +++ b/drivers/acpi/acpica/hwesleep.c
> >>> @@ -43,6 +43,7 @@
> >>>   */
> >>>
> >>>  #include <acpi/acpi.h>
> >>> +#include <linux/acpi.h>
> >>
> >> This also got complaints, so I'd be very surprised if they took it now.
> > 
> > I did see these complaints in the last version.
> > However, the file drivers/acpi/acpica/hwsleep.c contains this include,
> > and has since
> > 
> > commit 09f98a825a821f7a3f1b162f9ed023f37213a63b
> > Author: Tang Liang <liang.tang@oracle.com>
> > Date:   Fri Dec 9 10:05:54 2011 +0800
> > 
> > So since this is the extended sleep file, vs the standard one - I
> > don't see why such a restriction would be placed on the former, but
> > not the latter.
> 
> In essence they said (in the same thread I pointed you to) that
> according to the current policy this include is wrong and should
> be dropped.
> 
> Now, if you can get along without dropping it that'll likely be fine,
> but I doubt they'll allow you to add another instance of this.

Actually, I'd prefer not to add new dependencies on the "old" include either.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
