Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753486Ab3IQTlt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 15:41:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46299 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753301Ab3IQTls (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 15:41:48 -0400
Message-ID: <5238B070.8060803@redhat.com>
Date: Tue, 17 Sep 2013 15:41:36 -0400
From: "Carlos O'Donell" <carlos@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130805 Thunderbird/17.0.8
MIME-Version: 1.0
To: Peter Hurley <peter@hurleysoftware.com>
CC: Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        codonell <codonell@redhat.com>, Eduard Benes <ebenes@redhat.com>,
        Karel Srot <ksrot@redhat.com>, Matt Newsome <mnewsome@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] tty: disassociate_ctty() sends the extra SIGCONT
References: <20130915155006.GA11913@redhat.com> <20130915155026.GA11917@redhat.com> <52378345.50306@hurleysoftware.com>
In-Reply-To: <52378345.50306@hurleysoftware.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/16/2013 06:16 PM, Peter Hurley wrote:
> On 09/15/2013 11:50 AM, Oleg Nesterov wrote:
>> Starting from v3.10 (probably f91e2590 "tty: Signal foreground
>> group processes in hangup") disassociate_ctty() sends SIGCONT
>> if tty && on_exit. This breaks LSB test-suite, in particular
>> test8 in _exit.c and test40 in sigcon5.c.
>>
>> Put the "!on_exit" check back to restore the old behaviour.
>>
>> Cc: stable@vger.kernel.org # v3.10+
>> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
>> Reported-by: Karel Srot <ksrot@redhat.com>
> 
> Although I confirmed your results with a new unit test,
> I'd like to review the source code for the reported tests.
> Where can grab the source for the LSB tests, _exit.c and sigcon5.c?
> Direct links would be appreciated.

wget ftp://ftp.linuxfoundation.org/pub/lsb/test_suites/released-4.1/source/runtime/lsb-test-core-4.1.15-1.src.rpm
rpm2cpio lsb-test-core-4.1.15-1.src.rpm | cpio -idmv
tar zxvf lsb-test-core-4.1.15.tar.gz
tar zxvf lts_vsx-pcts-4.1.15.tgz

Source is at:
./tset/POSIX.os/procprim/_exit/_exit.c
./tset/POSIX.os/procprim/sigconcept/sigcon5.c

In all failures the tests are checking for SIGHUP to be sent
to a foreground process. It would appear that the additional
signal confuses the test.

Exactly what semantics should be followed do not seem to be
clearly covered by any standards. 

Therefore it is likely just as valid to say that the LSB tests
need to be more robust in the face of the additional signal.

I have little experience when it comes this particular area
of the kernel or expected behaviour from other OSs.

Cheers,
Carlos.
