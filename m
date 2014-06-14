Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754265AbaFNAtA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 20:49:00 -0400
Received: from mail-qa0-f54.google.com ([209.85.216.54]:65226 "EHLO
	mail-qa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753132AbaFNAs7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 20:48:59 -0400
From: =?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <j.glisse@gmail.com>
To: akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Cc: mgorman@suse.de, hpa@zytor.com, peterz@infraread.org,
        torvalds@linux-foundation.org, aarcange@redhat.com, riel@redhat.com,
        jweiner@redhat.com
Subject: HMM (Heterogeneous Memory Management) v3
Date: Fri, 13 Jun 2014 20:48:28 -0400
Message-Id: <1402706913-7432-1-git-send-email-j.glisse@gmail.com>
X-Mailer: git-send-email 1.9.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This v3 of HMM patchset previous discussion can be found at :
http://comments.gmane.org/gmane.linux.kernel.mm/116584

We would like to see this included especialy all preparatory patches are
they are cumberstone to rebase. They do not change any behavior except a
slightly increased stack consumption by adding new argument to mmu notifier
callback. I believe that those added argument might be of value not only
to HMM but also to other user of the mmu_notifier API.

I hide the HMM core function behind staging so people understand this is
not production ready but a base onto which we want to build support for all
HMM features.

In nutshell HMM is an API to simplify mirroring a process address space on
a secondary MMU that has its own page table (and most likely a different
page table format incompatible with the architecture page table). To ensure
that at all time CPU and mirroring device use the same page for the same
address for a process the use of the mmu notifier API is the only sane way.
This is because each CPU page table update is preceded or followed by a call
to the mmu notifier.

Andrew if you fear this feature will not be use by anyone i can ask NVidia
and/or AMD to public state their interest in it. So far HMM have been
developed in a close collaboration with NVidia but at Red Hat (and NVidia
is on board here) we want to make this as usefull as possible to other
consumer too and not only for GPU. So any one who has hardware with its
own MMU and its own page table and who wish to mirror a process address
space is welcome to join the discussion and to ask for features or to
discuss the API we expose to the device driver.

Like i said in v2, i stripped the remote memory support from this patchset
in order to make it easier to get the foundation in so that the remote
memory support is easier and less painfull to work on.

Changed since v2:
  - Hide core hmm behind staging
  - Fixed up all checkpatch.pl issues
  - Rebase on top of lastest linux-next

Note that the dummy driver is not necesarily to be included i added it
here so people can see an example driver. I however intend to grow the
functionalities of the hmm dummy driver in order to make a test and
regression suite for the core hmm.

Cheers,
Jérôme Glisse
