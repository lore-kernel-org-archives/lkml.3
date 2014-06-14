Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754649AbaFNJnV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2014 05:43:21 -0400
Received: from mail-we0-f180.google.com ([74.125.82.180]:57195 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754541AbaFNJnQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2014 05:43:16 -0400
MIME-Version: 1.0
In-Reply-To: <20140614000258.GA14900@madcap2.tricolour.ca>
References: <11db0d126ef0ec7506ef5cb6f2f21c926d206436.1396455228.git.rgb@redhat.com>
	<1396460387.20325.22.camel@dhcp-9-2-203-236.watson.ibm.com>
	<6292885.20TorKeRiK@x2>
	<1396462368.20325.26.camel@dhcp-9-2-203-236.watson.ibm.com>
	<1396462716.2608.1.camel@localhost>
	<1396463260.20325.28.camel@dhcp-9-2-203-236.watson.ibm.com>
	<20140402185250.GB24814@madcap2.tricolour.ca>
	<20140614000258.GA14900@madcap2.tricolour.ca>
Date: Sat, 14 Jun 2014 12:43:14 +0300
Message-ID: <CACE9dm83Kxbc3krVkCR9-Wy1Kq+YpEWRkLdbHDivwcxFtGjYmg@mail.gmail.com>
Subject: Re: [Linux-ima-user] oraphaned keywords in audit log text [was: Re:
 [PATCH] integrity: get comm using lock to avoid race in string] printing
From: Dmitry Kasatkin <dmitry.kasatkin@gmail.com>
To: Richard Guy Briggs <rgb@redhat.com>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>,
        linux-ima-user <linux-ima-user@lists.sourceforge.net>,
        linux-security-module <linux-security-module@vger.kernel.org>,
        linux-audit@redhat.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14 June 2014 03:02, Richard Guy Briggs <rgb@redhat.com> wrote:
> On 14/04/02, Richard Guy Briggs wrote:
>> On 14/04/02, Mimi Zohar wrote:
>> > On Wed, 2014-04-02 at 14:18 -0400, Eric Paris wrote:
>> > > On Wed, 2014-04-02 at 14:12 -0400, Mimi Zohar wrote:
>> > > > On Wed, 2014-04-02 at 14:00 -0400, Steve Grubb wrote:
>> > > > > Hello Mimi,
>> > > > >
>> > > > > On Wednesday, April 02, 2014 01:39:47 PM Mimi Zohar wrote:
>> > > > > > This change is already being upstreamed as commit 73a6b44 "Integrity:
>> > > > > > Pass commname via get_task_comm()".
>> > > > >
>> > > > > While I was looking at Richard's patch, I noticed a few places where cause and
>> > > > > op are logged and the string isn't tied together with a _ or -. These are in
>> > > > > ima/ima_appraise.c line 383, and ima/ima_policy.c lines 333, 657, and 683. Are
>> > > > > these fixed upstream? Or should a patch be made?
>> > > >
>> > > > Nothing has changed in terms of 'cause' and 'op'.  I would suggest
>> > > > making the changes in integrity_audit.c: integrity_audit_msg().
>>
>> That function could massage incoming text fields and convert spaces to
>> hyphens or underscores, but I'd assume the right place to do it would be
>> in the original text.  If you suggest the former, it could just be done
>> in audit_log_string(), but then grepping the source for error messages
>> would not be nearly as useful.  Is this what you were suggesting?
>>
>> > > The question is actually, do you know of anyone who is expecting the
>> > > space, instead of a more 'audit standard' - or _ ?  If not, we'll change
>> > > it.  If so, we'll discuss more   :)
>> >
>> > CC'ing linux-ima-user as well.
>>
>> Thanks.
>
> Was there any response from linux-ima-user?
>
>> > Mimi
>>
>> - RGB
>

Hi,

I will find this patch and have a look.

Thanks,

Dmitry

> - RGB
>
> --
> Richard Guy Briggs <rbriggs@redhat.com>
> Senior Software Engineer, Kernel Security, AMER ENG Base Operating Systems, Red Hat
> Remote, Ottawa, Canada
> Voice: +1.647.777.2635, Internal: (81) 32635, Alt: +1.613.693.0684x3545
>
> ------------------------------------------------------------------------------
> HPCC Systems Open Source Big Data Platform from LexisNexis Risk Solutions
> Find What Matters Most in Your Big Data with HPCC Systems
> Open Source. Fast. Scalable. Simple. Ideal for Dirty Data.
> Leverages Graph Analysis for Fast Processing & Easy Data Exploration
> http://p.sf.net/sfu/hpccsystems
> _______________________________________________
> Linux-ima-user mailing list
> Linux-ima-user@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/linux-ima-user



-- 
Thanks,
Dmitry
