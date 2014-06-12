Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756001AbaFLN1U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 09:27:20 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:39335 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755855AbaFLN1G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 09:27:06 -0400
Message-ID: <1402579513.1106.13.camel@debian>
Subject: Re: [PATCH] mm/vmscan.c: wrap five parameters into arg_container
 in shrink_page_list()
From: Chen Yucong <slaoub@gmail.com>
To: Rik van Riel <riel@redhat.com>
Cc: akpm@linux-foundation.org, mgorman@suse.de, hannes@cmpxchg.org,
        mhocko@suse.cz, linux-mm@kvack.org, linux-kernel@vger.kernel.org
In-Reply-To: <5399A0F3.8040106@redhat.com>
References: <1402565795-706-1-git-send-email-slaoub@gmail.com>
	 <5399A0F3.8040106@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 12 Jun 2014 21:25:13 +0800
Mime-Version: 1.0
X-Mailer: Evolution 3.4.4-3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-06-12 at 08:45 -0400, Rik van Riel wrote:
> > shrink_page_list() has too many arguments that have already reached
> ten.
> > Some of those arguments and temporary variables introduces extra 80
> bytes
> > on the stack.
> > 
> > This patch wraps five parameters into arg_container and removes some
> temporary
> > variables, thus making shrink_page_list() to consume fewer stack
> space.
> 
> Won't the container with those arguments now live on the stack,
> using up the same space that the variables used to take?
> 
Of course, the container with those arguments live on the stack.

One of the key reason for introducing this patch is to avoid passing
five pointer arguments to shrink_page_list().

The arg_container also uses up the same space that the variables used to
take.
If the those arguments is wrapped to arg_container, we just need to pass
one pointer to shrink_page_list instead of five.

thx!
cyc  

