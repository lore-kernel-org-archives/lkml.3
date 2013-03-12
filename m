Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933462Ab3CLUCY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 16:02:24 -0400
Received: from b-pb-sasl-quonix.pobox.com ([208.72.237.35]:42864 "EHLO
	smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755533Ab3CLUCW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 16:02:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=from:to:cc
	:subject:references:date:in-reply-to:message-id:mime-version
	:content-type; q=dns; s=sasl; b=F2szMvaICj9gGAjbddY/V+PJ4IvAoHmX
	kacmkWuh16mJZFELnggWL+aiRIxiKWnOEl58gqAAAB5TZTWunRiYvyQYO0LmVwjK
	bOAuI7iSQdsMJke3Wta/Ywv/hWVbJ0W1lOwZM9L6e5vKUObFUyTgfLLAXOwy1emW
	gCAUBAOWPSM=
From: Junio C Hamano <gitster@pobox.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>, James Morris <jmorris@namei.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Git Mailing List <git@vger.kernel.org>
Subject: Re: linux-next: unneeded merge in the security tree
References: <20130312100950.e45ef0e721492ff0d5fd7c8d@canb.auug.org.au>
 <alpine.LRH.2.02.1303121510270.25612@tundra.namei.org>
 <20130312041641.GE18595@thunk.org>
 <CA+55aFzFLDcN-1GKae6Xqrns59K1xOD_HPzuv2Lv1__fZpqFMw@mail.gmail.com>
 <7vsj40760d.fsf@alter.siamese.dyndns.org>
Date: Tue, 12 Mar 2013 13:02:19 -0700
In-Reply-To: <7vsj40760d.fsf@alter.siamese.dyndns.org> (Junio C. Hamano's
 message of "Tue, 12 Mar 2013 12:49:38 -0700")
Message-ID: <7vobeo75f8.fsf@alter.siamese.dyndns.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Pobox-Relay-ID: C016A4C0-8B4F-11E2-8500-26A52E706CDE-77302942!b-pb-sasl-quonix.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Junio C Hamano <gitster@pobox.com> writes:

> Then under the "--no-ff activates the magic" rule:
>
> 	git merge v3.9-rc2
>
> will fast-forward, but this
>
> 	git merge --no-ff v3.9-rc2
>
> creates a real merge with the "mergetag" signature block.  The one
> that caused trouble in the "security tree", i.e.
>
>         git pull linus v3.9-rc2
>
> or its equivalent
>
>         git fetch linus v3.9-rc2
>         git merge FETCH_HEAD
>
> would still fast-forward under this rule.  The maintainer needs to
> do
>
> 	git pull --no-ff git://git.kernel.org/... for-linus
>
> if the pull could fast-forward under this rule, though.

Scratch the last sentence.  It should have been

"whether the pull fast-forwards or not".  You'd always need to.
