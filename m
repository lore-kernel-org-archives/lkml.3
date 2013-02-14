Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761461Ab3BNBrP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 20:47:15 -0500
Received: from mail-vb0-f45.google.com ([209.85.212.45]:44197 "EHLO
	mail-vb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754001Ab3BNBrN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 20:47:13 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFws80EEJQskqiP+a5J-HOGu=M1Fe=uCs50ifedVxPxT1Q@mail.gmail.com>
References: <20130206150403.006e5294@cuia.bos.redhat.com> <tip-4aef331850b637169ff036ed231f0d236874f310@git.kernel.org>
 <CA+55aFx6N6SaRN+w=CTXJ=ZSsOE6KeS2R9sT_uhAx9h2j+hjKg@mail.gmail.com>
 <511BE4A3.8050607@redhat.com> <CA+55aFycMB7OZGQ54ueQ74C42beDBSdQE_fKJDV=TbjTjr_emg@mail.gmail.com>
 <511C1204.9040608@redhat.com> <CA+55aFwxYK-BLH0crhySHaQvAYHOH-VGUi7WTd1aq-24+WTDYw@mail.gmail.com>
 <511C24A6.8020409@redhat.com> <CA+55aFws80EEJQskqiP+a5J-HOGu=M1Fe=uCs50ifedVxPxT1Q@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 13 Feb 2013 17:46:52 -0800
X-Google-Sender-Auth: DWc15v_zs4qNIx6lKnLs1CxhDFQ
Message-ID: <CA+55aFxx7QDF0y=Rk0bSoDNKn-+=b96hYMYUJ0s31disRob0Wg@mail.gmail.com>
Subject: Re: [tip:core/locking] x86/smp: Move waiting on contended ticket lock
 out of line
To: Rik van Riel <riel@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, aquini@redhat.com,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Michel Lespinasse <walken@google.com>,
        linux-tip-commits@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 13, 2013 at 5:21 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> Now, on other machines you get the call chain even with pebs because
> you can get the whole

Oops, that got cut short early, because I started looking up when PEBS
and the last-branch-buffer work together, and couldn't find it, and
then came back to the email and forgot to finish the sentence.

Anyway: sometimes you get call chains with precise events, sometimes
you don't. And it turns out that I can't find out which cores do both,
and which ones don't.

                Linus
