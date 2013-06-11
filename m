Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755194Ab3FKQhm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 12:37:42 -0400
Received: from mail-ee0-f47.google.com ([74.125.83.47]:55132 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752956Ab3FKQhl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 12:37:41 -0400
Message-ID: <1370968655.3252.49.camel@edumazet-glaptop>
Subject: Re: [PATCH] slab: prevent warnings when allocating with __GFP_NOWARN
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Christoph Lameter <cl@gentwo.org>, Pekka Enberg <penberg@kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Tue, 11 Jun 2013 09:37:35 -0700
In-Reply-To: <51B74E28.4070906@oracle.com>
References: <1370891880-2644-1-git-send-email-sasha.levin@oracle.com>
	  <CAOJsxLGDH2iwznRkP-iwiMZw7Ee3mirhjLvhShrWLHR0qguRxA@mail.gmail.com>
	  <51B62F6B.8040308@oracle.com>
	  <0000013f3075f90d-735942a8-b4b8-413f-a09e-57d1de0c4974-000000@email.amazonses.com>
	  <51B67553.6020205@oracle.com>
	  <CAOJsxLH56xqCoDikYYaY_guqCX=S4rcVfDJQ4ki=r-PkNQW9ug@mail.gmail.com>
	  <51B72323.8040207@oracle.com>
	  <0000013f33cdc631-eadb07d1-ef08-4e2c-a218-1997eb86cde9-000000@email.amazonses.com>
	  <51B73F38.6040802@kernel.org>
	  <0000013f33d58923-88767793-2187-476d-b500-dba3c22607aa-000000@email.amazonses.com>
	  <51B745F9.9080609@oracle.com> <1370967193.3252.47.camel@edumazet-glaptop>
	 <51B74E28.4070906@oracle.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-06-11 at 12:19 -0400, Sasha Levin wrote:

> It might be, but you need CAP_SYS_RESOURCE to go into the dangerous
> zone (>pipe_max_size).
> 
> So if root (or someone with that cap) wants to go there, as Rusty says:
> "Root asked, we do."

Yes and no : adding a test to select vmalloc()/vfree() instead of
kmalloc()/kfree() will slow down regular users asking 32 pages in their
pipe.

If there is no _sensible_ use for large pipes even for root, please do
not bloat the code just because we can.



