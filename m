Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753398AbaA0HOP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 02:14:15 -0500
Received: from mail-ee0-f43.google.com ([74.125.83.43]:63806 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751135AbaA0HON (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 02:14:13 -0500
Date: Mon, 27 Jan 2014 08:14:10 +0100
From: Ingo Molnar <mingo@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Prarit Bhargava <prarit@redhat.com>, Yinghai Lu <yinghai@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -v2] x86: allocate cpumask during check irq vectors
Message-ID: <20140127071410.GA19617@gmail.com>
References: <1390611565-18709-1-git-send-email-yinghai@kernel.org>
 <20140125080232.GA20935@gmail.com>
 <52E4FE02.2020004@redhat.com>
 <20140126133203.GA1370@gmail.com>
 <52E55FB1.4060404@redhat.com>
 <20140126202140.GB8224@gmail.com>
 <4f0b30ff-6adb-46f5-bad4-ed42956e2a39@email.android.com>
 <20140126202749.GA10254@gmail.com>
 <eb93bdba-d16d-4a85-ae40-f265b1db5ed4@email.android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eb93bdba-d16d-4a85-ae40-f265b1db5ed4@email.android.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* H. Peter Anvin <hpa@zytor.com> wrote:

> I strongly disagree with putting variables in file scope when 
> function scope will do, [...]

Yes, you are right that single-use file scope statics 'could' be moved 
function local and are syntactically superior because in that case 
other functions cannot make use of it.

But I also have very good (and unfixable and thus stronger) reasons to 
object to statics inside local variables: more than once I personally 
missed 'hidden statics' during review, in one case it even slipped 
into a commit, so it's not a practice I want to encourage in any shape 
or form (even if the 'rule' is to have a big fat comment, people will 
just see the function local static and emulate it without the 
comment), for code I maintain.

It's not about you, it's about me and other reviewers: I've seen 
statics slipping past other reviewers as well. So it's the lesser of 
two evils. Can you accept that reasoning?

Thanks,

	Ingo
