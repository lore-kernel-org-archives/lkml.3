Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755022Ab3COPNq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 11:13:46 -0400
Received: from mail-vc0-f182.google.com ([209.85.220.182]:38385 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753867Ab3COPNp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 11:13:45 -0400
MIME-Version: 1.0
In-Reply-To: <20130315134632.GA18335@redhat.com>
References: <20130314162413.GA21344@redhat.com>
	<CACVXFVP+fGeWS3xwBfaQDFaH7=e_4CbgCru9DJczB2vyWuUL1g@mail.gmail.com>
	<20130315134632.GA18335@redhat.com>
Date: Fri, 15 Mar 2013 23:13:43 +0800
Message-ID: <CACVXFVOjWc4RU+A-8PeYP9RfJ1-HSiZHbbv771LXDynMs0ybMQ@mail.gmail.com>
Subject: Re: + atomic-improve-atomic_inc_unless_negative-atomic_dec_unless_positive
 .patch added to -mm tree
From: Ming Lei <tom.leiming@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Shaohua Li <shli@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 15, 2013 at 9:46 PM, Oleg Nesterov <oleg@redhat.com> wrote:
> On 03/15, Ming Lei wrote:
>>
>> On Fri, Mar 15, 2013 at 12:24 AM, Oleg Nesterov <oleg@redhat.com> wrote:
>> >  static inline int atomic_inc_unless_negative(atomic_t *p)
>> >  {
>> >         int v, v1;
>> > -       for (v = 0; v >= 0; v = v1) {
>> > +       for (v = atomic_read(p); v >= 0; v = v1) {
>> >                 v1 = atomic_cmpxchg(p, v, v + 1);
>>
>> Unfortunately, the above will exchange the current value even though
>> it is negative, so it isn't correct.
>
> Hmm, why? We always check "v >= 0" before we try to do
> atomic_cmpxchg(old => v) ?

Sorry, yes, you are right. But then your patch is basically same with the
previous one, isn't it?  And has same problem, see below discussion:

http://marc.info/?t=136284366900001&r=1&w=2


Thanks,
-- 
Ming Lei
