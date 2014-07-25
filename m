Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760126AbaGYLUu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 07:20:50 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:34754 "EHLO
	out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752040AbaGYLUq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 07:20:46 -0400
X-Sasl-enc: eaCBMKc6YQteyP/dfwQtkwqyLQY1Z2Li2v7QeGYf9nQh 1406287245
Date: Fri, 25 Jul 2014 08:20:39 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Toralf =?iso-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>
Cc: linux-ia64@vger.kernel.org, ceph-devel@vger.kernel.org,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: sizeof (struct tYpO *) : it is just a typo or rather a bug ?
Message-ID: <20140725112038.GA401@khazad-dum.debian.net>
References: <53D14E60.1010105@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <53D14E60.1010105@gmx.de>
X-GPG-Fingerprint1: 4096R/39CB4807 C467 A717 507B BAFE D3C1  6092 0BD9 E811
 39CB 4807
X-GPG-Fingerprint2: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Jul 2014, Toralf Förster wrote:
> Inspired by this "typo" fix 
> http://article.gmane.org/gmane.linux.kernel/1754640
> I grep'ed the current git tree of linus for similar issues.

I wonder if we couldn't use Coccinelle to do that?  I would say it would be
not as cool as deep grep magick, but Coccinelle is cool by definition and
therefore immune from any such comparisons :-)

> Nevertheless I was told, that gcc doesn't complain about such things due
> to eventually evaluating it to "sizeof(null)". I'm however curious if at
> least a warning should be emitted in such a case, or?

Well, it cannot become a real bug because the moment the code changes to
actually access/derreference such a typo, it will cause the compiler to
abort with an error.  If gcc will have to waste a measurable amount of time
to issue such a warning, it is not worth it.

OTOH, such typos could confuse someone reading the code into thinking
they're dealing with a different structure or something, and it _is_
incorrect code no matter how harmless, so it makes sense to fix all such
typos eventually.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
