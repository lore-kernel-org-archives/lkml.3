Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756923Ab3JNWNw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 18:13:52 -0400
Received: from a9-70.smtp-out.amazonses.com ([54.240.9.70]:60779 "EHLO
	a9-70.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756107Ab3JNWNt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 18:13:49 -0400
Date: Mon, 14 Oct 2013 22:13:48 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-arch@vger.kernel.org
Subject: Re: [PATCH 34/34] mm: dynamically allocate page->ptl if it cannot
 be embedded to struct page
In-Reply-To: <20131014212514.C7C19E0090@blue.fi.intel.com>
Message-ID: <00000141b90841a8-3fb61f1e-89aa-4a35-94d4-a264ac91462b-000000@email.amazonses.com>
References: <1381428359-14843-1-git-send-email-kirill.shutemov@linux.intel.com> <1381428359-14843-35-git-send-email-kirill.shutemov@linux.intel.com> <00000141a3f48ada-37ee9c14-2f2b-40a2-93f4-70258363351b-000000@email.amazonses.com> <20131010200921.91D84E0090@blue.fi.intel.com>
 <00000141a7d2aa7b-e59f292a-746c-4f55-aa51-9fa060a7fbeb-000000@email.amazonses.com> <20131014090437.F22CBE0090@blue.fi.intel.com> <00000141b85a90a0-7cf6bab0-4c17-4fc0-8224-74bbb1fc85ee-000000@email.amazonses.com>
 <20131014212514.C7C19E0090@blue.fi.intel.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.10.14-54.240.9.70
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Oct 2013, Kirill A. Shutemov wrote:

> Feel free to propose a patch. I don't see much point.

Right now you are using a long to stand in for a spinlock_t or a pointer
to a spinlock_t. An #ifdef would allow to define the proper type and
therefore the compiler to check that the ptl is correctly used.

