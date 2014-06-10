Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753924AbaFJVVJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 17:21:09 -0400
Received: from qmta09.emeryville.ca.mail.comcast.net ([76.96.30.96]:50284 "EHLO
	qmta09.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753665AbaFJVVI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 17:21:08 -0400
Date: Tue, 10 Jun 2014 16:21:04 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Dave Hansen <dave.hansen@intel.com>, Hugh Dickins <hughd@google.com>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Vlastimil Babka <vbabka@suse.cz>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH, RFC 00/10] THP refcounting redesign
In-Reply-To: <20140610204640.GA9594@node.dhcp.inet.fi>
Message-ID: <alpine.DEB.2.10.1406101616520.20047@gentwo.org>
References: <1402329861-7037-1-git-send-email-kirill.shutemov@linux.intel.com> <alpine.DEB.2.10.1406101518510.19364@gentwo.org> <20140610204640.GA9594@node.dhcp.inet.fi>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Jun 2014, Kirill A. Shutemov wrote:

> Could you elaborate here?

The page migration scheme works by locking and also putting in a fake pte
to ensure that any accesses cause a page fault which will then block.
In the THP case we would need a fake pmd.

That allows effectively to force all accesses to the page to stop. Then
you do the page migration (and you could do the splitting etc) and then
replace the fake pmd/pte with real ones.

See the page migration code.

> Agreed. The patchset drops tail page refcounting.

Great. Step in the right diretion.
