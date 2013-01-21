Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752694Ab3AUCA2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2013 21:00:28 -0500
Received: from b-pb-sasl-quonix.pobox.com ([208.72.237.35]:37730 "EHLO
	smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752559Ab3AUCA0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2013 21:00:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=from:to:cc
	:subject:references:date:in-reply-to:message-id:mime-version
	:content-type; q=dns; s=sasl; b=d7d07JPT5CRg03kpKG26sl3mcy/5Wgwo
	3vzpfMa4UylPqjb6quSMPiMc8OJ3rzTaROyD2eP4i/Cxi9YCjdTWCsiNPaGNdAoC
	59HArCSvSee9tT0GTL+bMgPCWfpWCA9KnznEvaKs1GhXzf6nK9p6N8sQLIONHSoM
	rqMJ5qjci6k=
From: Junio C Hamano <gitster@pobox.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        Git Mailing List <git@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Alexander Graf <agraf@suse.de>,
        Prarit Bhargava <prarit@redhat.com>,
        Sasha Levin <sasha.levin@oracle.com>
Subject: Re: [PULL] Module fixes, and a virtio block fix.
References: <87zk03wg7r.fsf@rustcorp.com.au>
 <CA+55aFwzdcv0LXovZobha=EH=L6DapJt+ODP0nq=TWWAqCxLYQ@mail.gmail.com>
 <87fw1vwcao.fsf@rustcorp.com.au>
 <CA+55aFy1nW859yaGP17epRX8A+TaJ8APvb0-Ww1zw91dCAOhoQ@mail.gmail.com>
Date: Sun, 20 Jan 2013 18:00:24 -0800
In-Reply-To: <CA+55aFy1nW859yaGP17epRX8A+TaJ8APvb0-Ww1zw91dCAOhoQ@mail.gmail.com> (Linus
 Torvalds's message of "Sun, 20 Jan 2013 17:45:33 -0800")
Message-ID: <7vpq0zi9c7.fsf@alter.siamese.dyndns.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Pobox-Relay-ID: 529AEDCE-636E-11E2-8C23-F0CE2E706CDE-77302942!b-pb-sasl-quonix.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> On Sun, Jan 20, 2013 at 5:32 PM, Rusty Russell <rusty@rustcorp.com.au> wrote:
>>
>> Due to the delay on git.kernel.org, git request-pull fails.  It *looks*
>> like it succeeds, except the warning, but (as we learned last time I
>> screwed up), it doesn't put the branchname because it can't know.
>
> I think this should be fixed in modern git versions.
> ...
> Junio, didn't "git request-pull" get fixed so that it *warns* about
> missing tagnames/branches, but never actually corrupts the pull
> request? Or did it just get "fixed" to be a hard error instead of
> corrupting things? Because this is annoying.

What you mean by "corrupt" is not clear to me, but the last change
to the script is from 6 months ago to solve a related (perhaps the
same?) problem, which should be in v1.7.11.2 and later:

    request-pull: really favor a matching tag

    After tagging the tip of "dev" branch with a "for-linus" tag and
    pushing both out, running

        $ git request-pull $url $last_release dev

    would produce an output asking the 'dev' branch of $url to be
    pulled, because that is what the user asked the message to say.

    We already detect this situation locally and include the
    contents of the tag in the output; if the $url has that tag,
    favor that tag (i.e. "for-linus") in the generated message over
    the branch name the user gave us (i.e. "dev") from the command
    line, to make the output look more consistent.
