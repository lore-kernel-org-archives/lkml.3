Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754542AbaLBLat (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 06:30:49 -0500
Received: from mta-out1.inet.fi ([62.71.2.203]:40470 "EHLO jenni2.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751591AbaLBLas (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 06:30:48 -0500
Date: Tue, 2 Dec 2014 13:30:14 +0200
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: "Wang, Yalin" <Yalin.Wang@sonymobile.com>
Cc: "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'linux-mm@kvack.org'" <linux-mm@kvack.org>,
        "'linux-arm-kernel@lists.infradead.org'" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC V2] mm:add zero_page _mapcount when mapped into user space
Message-ID: <20141202113014.GA22683@node.dhcp.inet.fi>
References: <35FD53F367049845BC99AC72306C23D103E688B313E0@CNBJMBX05.corpusers.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <35FD53F367049845BC99AC72306C23D103E688B313E0@CNBJMBX05.corpusers.net>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 02, 2014 at 05:27:36PM +0800, Wang, Yalin wrote:
> This patch add/dec zero_page's _mapcount to make sure
> the mapcount is correct for zero_page,
> so that when read from /proc/kpagecount, zero_page's
> mapcount is also correct, userspace process like procrank can
> calculate PSS correctly.

I don't have specific code path to point to, but I would expect zero page
with non-zero mapcount would cause a problem with rmap.

How do you test the change?

-- 
 Kirill A. Shutemov
