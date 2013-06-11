Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754348Ab3FKPQN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 11:16:13 -0400
Received: from mail-lb0-f169.google.com ([209.85.217.169]:49491 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751343Ab3FKPQM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 11:16:12 -0400
Message-ID: <51B73F38.6040802@kernel.org>
Date: Tue, 11 Jun 2013 18:16:08 +0300
From: Pekka Enberg <penberg@kernel.org>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Christoph Lameter <cl@gentwo.org>
CC: Sasha Levin <sasha.levin@oracle.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] slab: prevent warnings when allocating with __GFP_NOWARN
References: <1370891880-2644-1-git-send-email-sasha.levin@oracle.com> <CAOJsxLGDH2iwznRkP-iwiMZw7Ee3mirhjLvhShrWLHR0qguRxA@mail.gmail.com> <51B62F6B.8040308@oracle.com> <0000013f3075f90d-735942a8-b4b8-413f-a09e-57d1de0c4974-000000@email.amazonses.com> <51B67553.6020205@oracle.com> <CAOJsxLH56xqCoDikYYaY_guqCX=S4rcVfDJQ4ki=r-PkNQW9ug@mail.gmail.com> <51B72323.8040207@oracle.com> <0000013f33cdc631-eadb07d1-ef08-4e2c-a218-1997eb86cde9-000000@email.amazonses.com>
In-Reply-To: <0000013f33cdc631-eadb07d1-ef08-4e2c-a218-1997eb86cde9-000000@email.amazonses.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Jun 2013, Sasha Levin wrote:
>> I think that leaving the warning makes sense to catch similar
>> things which are actually bugs - we had a similar issue with
>> /dev/kmsg (if I remember correctly) which actually pointed to
>> a bug.

On 6/11/13 6:14 PM, Christoph Lameter wrote:
> Right. Requesting an allocation larger than even supported by the page
> allocator from the slab allocators that are specializing in allocations of
> small objects is usually an indication of a problem in the code.

So you're OK with going forward with Sasha's patch? It's needed
because __GFP_NOWARN was specifically added there to fix this
issue earlier.

			Pekka
