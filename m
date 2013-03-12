Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933629Ab3CLVaK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 17:30:10 -0400
Received: from b-pb-sasl-quonix.pobox.com ([208.72.237.35]:43565 "EHLO
	smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932707Ab3CLVaH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 17:30:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=from:to:cc
	:subject:references:date:in-reply-to:message-id:mime-version
	:content-type; q=dns; s=sasl; b=MQpJBbHQjd5RCPfKGBe1SMcGknvuH+Vb
	B//64o9P/RlTJH57VCs/Xp8lDpEnKwvp4bV++H2SUo2wXsunvZBNVuv9umw+0qEo
	GRUfo8ewVtbrXSxsPY31I2KwX9cGIjLL2i91tKdeZ3z5OKRJzRGtczX7moxPrCK+
	2ZhNAWTTf3w=
From: Junio C Hamano <gitster@pobox.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        James Morris <jmorris@namei.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Git Mailing List <git@vger.kernel.org>
Subject: Re: linux-next: unneeded merge in the security tree
References: <20130312100950.e45ef0e721492ff0d5fd7c8d@canb.auug.org.au>
 <alpine.LRH.2.02.1303121510270.25612@tundra.namei.org>
 <20130312041641.GE18595@thunk.org>
 <CA+55aFzFLDcN-1GKae6Xqrns59K1xOD_HPzuv2Lv1__fZpqFMw@mail.gmail.com>
 <20130312212027.GE14792@thunk.org>
Date: Tue, 12 Mar 2013 14:30:04 -0700
In-Reply-To: <20130312212027.GE14792@thunk.org> (Theodore Ts'o's message of
 "Tue, 12 Mar 2013 17:20:27 -0400")
Message-ID: <7vtxog5msj.fsf@alter.siamese.dyndns.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Pobox-Relay-ID: 023C2454-8B5C-11E2-9021-26A52E706CDE-77302942!b-pb-sasl-quonix.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Theodore Ts'o <tytso@mit.edu> writes:

> What if we added the ability to do something like this:
>
> [remote "origin"]
> 	url = git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
> 	fetch = +refs/heads/master:refs/heads/master
> 	mergeoptions = --ff-only
>
> This would be an analog to branch.<name>.mergeoptions, but it would
> apply to the source of the pull request, instead of the destination.
>
> That way, people who do a "git pull" from Linus's tree would get the
> protection of --ff-only, while pulls from submaintainer trees would
> automatically get a merge commit, which is what we want.
>
> It doesn't handle the case of a submaintainer pulling from a
> maintainer in a back-merge scenario, but that should be a pretty rare
> case, so maybe that's OK.

Is there an escape hatch for that rare case?  IOW, how does a
submaintainer who configured the above to override --ff-only?

