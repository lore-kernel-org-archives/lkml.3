Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753883AbbA2GeI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 01:34:08 -0500
Received: from pb-smtp1.int.icgroup.com ([208.72.237.35]:60770 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752736AbbA2GeF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 01:34:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=from:to:cc
	:subject:references:date:in-reply-to:message-id:mime-version
	:content-type; q=dns; s=sasl; b=hIUWnQMJO5SKjB1g0PnE+j64Ghr7qZF6
	DzjWo5WNQrrUULZ37NZdMfxFmBHP5CUhld4I3JRkgqbzGhlvUlo4ofhTlK7Nq/RZ
	US6V17J5AfvimDAOrod5wAM7eeWfyKreY/YKCM1ydX51V1XGc+VBfctjHXikRTyN
	yP+4B/ENHpQ=
From: Junio C Hamano <gitster@pobox.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jeff King <peff@peff.net>, Josh Boyer <jwboyer@fedoraproject.org>,
        "Linux-Kernel\@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        twaugh@redhat.com, Git Mailing List <git@vger.kernel.org>
Subject: Re: patch-2.7.3 no longer applies relative symbolic link patches
References: <CA+5PVA7rVy6Li_1haj1QmGG0D6avLB5Xej=2YGt6K-11kKHR5A@mail.gmail.com>
	<CA+5PVA4bs6CYU8MHn1JqBjnb-5wYJT2Tjqa65=v2uSPL8c7dYw@mail.gmail.com>
	<CA+55aFxbY21vBbPs5qCFPT1HSBbaeS+Z2Fr9So1r3rXrMWe_ZQ@mail.gmail.com>
	<xmqqzj94lx7z.fsf@gitster.dls.corp.google.com>
	<xmqqa914klg0.fsf@gitster.dls.corp.google.com>
	<xmqqfvauf7ej.fsf@gitster.dls.corp.google.com>
Date: Wed, 28 Jan 2015 22:34:03 -0800
In-Reply-To: <xmqqfvauf7ej.fsf@gitster.dls.corp.google.com> (Junio C. Hamano's
	message of "Wed, 28 Jan 2015 22:05:56 -0800")
Message-ID: <xmqqtwzadrj8.fsf@gitster.dls.corp.google.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Pobox-Relay-ID: D1C71494-A780-11E4-A367-7BA29F42C9D4-77302942!pb-smtp1.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Junio C Hamano <gitster@pobox.com> writes:

> Subject: [PATCH] apply: refuse touching a file beyond symlink
>
> Because Git tracks symbolic links as symbolic links, a path that has
> a symbolic link in its leading part (e.g. path/to/dir being a
> symbolic link to somewhere else, be it inside or outside the working
> tree) can never appear in a patch that validly apply, unless the
> same patch first removes the symbolic link.

I should rephrase the above to make it more readable.

    ... its leading part (e.g. path/to/dir/file, where path/to/dir is a
    symbolic link to somewhere else, ...

is what I meant to say.
