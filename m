Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934294Ab3E1OR1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 10:17:27 -0400
Received: from mail-lb0-f177.google.com ([209.85.217.177]:55745 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934176Ab3E1OR0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 10:17:26 -0400
MIME-Version: 1.0
In-Reply-To: <20130524143759.GA4404@phenom.dumpdata.com>
References: <1365692161-13735-1-git-send-email-dgdegra@tycho.nsa.gov>
 <20130522191551.GB10617@phenom.dumpdata.com> <CAM0nabGSo9b7q1pGOsTGjFzJBi7cK=2s5mGmOgNjeAf-2+ZvDQ@mail.gmail.com>
 <20130522205704.GB12923@phenom.dumpdata.com> <CAM0nabFO_tTqsX5c7Q-Z14CbRnqo9m11f__xkfzt6c8M026D_A@mail.gmail.com>
 <20130524143759.GA4404@phenom.dumpdata.com>
From: Kent Yoder <shpedoikal@gmail.com>
Date: Tue, 28 May 2013 09:16:54 -0500
Message-ID: <CAM0nabHdwNPad8FLk9YpLJ_MBcW++4+wBAajK8mRbRyDG9zCUA@mail.gmail.com>
Subject: Re: [tpmdd-devel] [PATCH v2] drivers/tpm: add xen tpmfront interface
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: leosilva@linux.vnet.ibm.com, adlai@linux.vnet.ibm.com,
        Daniel De Graaf <dgdegra@tycho.nsa.gov>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        TPM Device Driver List <tpmdd-devel@lists.sourceforge.net>,
        Ian.Campbell@citrix.com, Jan Beulich <JBeulich@suse.com>,
        xen-devel@lists.xen.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 24, 2013 at 9:37 AM, Konrad Rzeszutek Wilk
<konrad.wilk@oracle.com> wrote:
> On Wed, May 22, 2013 at 05:12:24PM -0500, Kent Yoder wrote:
>> On Wed, May 22, 2013 at 3:57 PM, Konrad Rzeszutek Wilk
>> <konrad.wilk@oracle.com> wrote:
>> > On Wed, May 22, 2013 at 02:47:01PM -0500, Kent Yoder wrote:
>> >> >> +     notify_remote_via_evtchn(priv->evtchn);
>> >> >> +
>> >> >> +     ordinal = be32_to_cpu(*((__be32 *) (buf + 6)));
>> >> >
>> >> > Um, + 6? Why? Is there an #define for that magic constant?
>> >> > Should this value be read before you do the wait_for_tpm_stat stuff?
>> >>
>> >>   This is hardcoded to 6 even in tpm.c.  Time for a #define...
>> >>
>> >> > Otherwise it looks OK to me. Should this go through me or Kent?
>> >> > And if so, is Kent waiting for my feedback?
>> >>
>> >>   My comments were minor -- I was expecting feedback on your earlier
>> >> comments before merging.  I think this should go through the tpmdd
>> >> maintainer if its going to live in drivers/char/tpm though.
>> >
>> > That is you I thought?
>> >
>> > konrad@phenom:~/mm$ scripts/get_maintainer.pl -f drivers/char/tpm
>> > Kent Yoder <key@linux.vnet.ibm.com> (maintainer:TPM DEVICE DRIVER)
>> > Rajiv Andrade <mail@srajiv.net> (maintainer:TPM DEVICE DRIVER)
>> > Marcel Selhorst <tpmdd@selhorst.net> (maintainer:TPM DEVICE DRIVER)
>> > Sirrix AG <tpmdd@sirrix.com> (maintainer:TPM DEVICE DRIVER)
>> > tpmdd-devel@lists.sourceforge.net (moderated list:TPM DEVICE DRIVER)
>> > linux-kernel@vger.kernel.org (open list)
>>
>> That was me until today. :-)  But I didn't see the response your comments yet.
>
> Congratulations to you on a move to a new job!! Can you say what it is?

  Thanks, yeah I'm headed to Cisco -- the job will focus on pen
testing and some security research.

Kent

> I am sure Daniel will post a patch shortly, and will CC everybody that get_maintainer.pl
> finds.
