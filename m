Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754522AbaGZTwn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 15:52:43 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:34737 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752760AbaGZTwj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 15:52:39 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andy Lutomirski <luto@amacapital.net>
Cc: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Julien Tinnes <jln@google.com>, David Drysdale <drysdale@google.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Paolo Bonzini <pbonzini@redhat.com>,
        LSM List <linux-security-module@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Paul Moore <paul@paul-moore.com>,
        James Morris <james.l.morris@oracle.com>,
        Linux API <linux-api@vger.kernel.org>,
        Meredydd Luff <meredydd@senatehouse.org>,
        Christoph Hellwig <hch@infradead.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kees Cook <keescook@chromium.org>, "Theodore Ts'o" <tytso@mit.edu>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        linux-crypto@vger.kernel.org
References: <CALCETrWGvBfrX1W5XaFgJZhKHLf+oac9YrwPR3ppK=deQtu5hA@mail.gmail.com>
	<20140725223550.3153f436@alan.etchedpixels.co.uk>
	<CALCETrXHNFYaQjksBJyN3O0HJpKw_D_tU7b4O23=nyJt9CPSLg@mail.gmail.com>
Date: Sat, 26 Jul 2014 12:48:48 -0700
In-Reply-To: <CALCETrXHNFYaQjksBJyN3O0HJpKw_D_tU7b4O23=nyJt9CPSLg@mail.gmail.com>
	(Andy Lutomirski's message of "Fri, 25 Jul 2014 14:41:47 -0700")
Message-ID: <87egx7dhpb.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX18LVE//GcchXoJsHHCqNJqPzV4ffvhw7z0=
X-SA-Exim-Connect-IP: 98.234.51.111
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.5000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Andy Lutomirski <luto@amacapital.net>
X-Spam-Relay-Country: 
Subject: Re: General flags to turn things off (getrandom, pid lookup, etc)
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 13:58:17 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andy Lutomirski <luto@amacapital.net> writes:

> On Fri, Jul 25, 2014 at 2:35 PM, One Thousand Gnomes
> <gnomes@lxorguk.ukuu.org.uk> wrote:
>> On Fri, 25 Jul 2014 11:30:48 -0700
>> Andy Lutomirski <luto@amacapital.net> wrote:
>>
>>> [new thread because this sort of combines two threads]
>>>
>>> There is recent interest in having a way to turn generally-available
>>> kernel features off.  Maybe we should add a good one so we can stop
>>> bikeshedding and avoid proliferating dumb interfaces.
>>
>> We sort of have one. It's called capable(). Just needs extending to cover
>> anything else you care about, and probably all the numeric constants
>> replacing with textual names.

The big difference is capable only subdivides roots powers (aka things
most applications should not have).  When we start talking about things
that things that are safe for most applications capable is probably not
the right tool for the job.

A much closer match is the personality system call.  Look at setarch
to see how it is used.  My biggest concern with personality is there
are only 32bits to play with.  Still I expect what you want may be a
sandbox personality, that disables everything that could possibly be
a problem (including access to the personality syscall).

Eric
