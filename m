Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754838AbaIVUX7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 16:23:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48506 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754424AbaIVUX5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 16:23:57 -0400
Message-ID: <54208422.8010209@redhat.com>
Date: Mon, 22 Sep 2014 16:18:42 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Andres Lagar-Cavilla <andreslc@google.com>, Gleb Natapov <gleb@kernel.org>,
        Radim Krcmar <rkrcmar@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Peter Feiner <pfeiner@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
CC: Andres Lagar-Cavilla <andreslc@gooogle.com>
Subject: Re: [PATCH] kvm: Fix page ageing bugs
References: <1411415878-30346-1-git-send-email-andreslc@google.com>
In-Reply-To: <1411415878-30346-1-git-send-email-andreslc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 09/22/2014 03:57 PM, Andres Lagar-Cavilla wrote:
> 1. We were calling clear_flush_young_notify in unmap_one, but we
> are within an mmu notifier invalidate range scope. The spte exists
> no more (due to range_start) and the accessed bit info has already
> been propagated (due to kvm_pfn_set_accessed). Simply call 
> clear_flush_young.
> 
> 2. We clear_flush_young on a primary MMU PMD, but this may be
> mapped as a collection of PTEs by the secondary MMU (e.g. during
> log-dirty). This required expanding the interface of the
> clear_flush_young mmu notifier, so a lot of code has been trivially
> touched.
> 
> 3. In the absence of shadow_accessed_mask (e.g. EPT A bit), we
> emulate the access bit by blowing the spte. This requires proper
> synchronizing with MMU notifier consumers, like every other removal
> of spte's does.

Acked-by: Rik van Riel <riel@redhat.com>


- -- 
All rights reversed
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBAgAGBQJUIIQiAAoJEM553pKExN6DWeoH/RpkYF1QCxnbxgZhnioaWjyu
Rp/kN6Rck6Eu3k/yRI6k+8IhgUJWkVhSXybTIDl1X6aVGgYwhaeOv2zPPfshfM6h
ABE3pLFjs2qtdotZXFSvZ4mNwbQE73YHphAbmFUBSdm2Oz1bj6Qfq+KYFdM+aQd7
UYIFgtdGg/tyLMqE25J7pAnSDRR5GKmAKLvkFjN3Q8O4ynD3rExH1yTMLtQbyKvb
oadSzaQLBOkLDAj3rpiOTl52B2tlQS+cxWqEfzA/AXOK8TkllDKIQT5BeRXV5O1c
/WsZmusiA6KYgjLxnL0K9XJpgpOQ5unYAFyIGgYmKiaN6PQsd+pGM5GDnOWGorE=
=dftO
-----END PGP SIGNATURE-----
