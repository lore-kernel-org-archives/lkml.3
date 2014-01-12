Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751207AbaALQO6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jan 2014 11:14:58 -0500
Received: from mail-pb0-f43.google.com ([209.85.160.43]:65154 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899AbaALQO4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jan 2014 11:14:56 -0500
MIME-Version: 1.0
X-Originating-IP: [67.83.169.196]
In-Reply-To: <20140106204706.GA16924@leaf>
References: <20140106204706.GA16924@leaf>
Date: Sun, 12 Jan 2014 11:14:56 -0500
Message-ID: <CA+C-WL_Z6TuWTO00gzgJo3+D-kHfjFBrfACqpaDCNxP23-LN_g@mail.gmail.com>
Subject: Re: #pragma once?
From: Patrick Palka <patrick@parcs.ath.cx>
To: Josh Triplett <josh@joshtriplett.org>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Michal Marek <mmarek@suse.cz>, Sam Ravnborg <sam@ravnborg.org>,
        Rashika Kheria <rashika.kheria@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 6, 2014 at 3:47 PM, Josh Triplett <josh@joshtriplett.org> wrote:
> Does anyone have any objection to the use of "#pragma once" instead of
> the usual #ifndef-#define-...-#endif include guard?  GCC, LLVM/clang,
> and the latest Sparse all support either method just fine.  (I added
> support to Sparse myself.)  Both have equivalent performance.  "#pragma
> once" is simpler, and avoids the possibility of a typo in the defined
> guard symbol.

Unfortunately in GCC #pragma once is slower and slightly buggier than
regular include guards:

http://gcc.gnu.org/bugzilla/show_bug.cgi?id=52566
http://gcc.gnu.org/bugzilla/show_bug.cgi?id=58770
