Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752230Ab3F3Sde (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Jun 2013 14:33:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27605 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751969Ab3F3Sdc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Jun 2013 14:33:32 -0400
Date: Sun, 30 Jun 2013 20:28:37 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Valdis.Kletnieks@vt.edu
Cc: Randy Dunlap <rdunlap@infradead.org>, akpm@linux-foundation.org,
        mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-next@vger.kernel.org
Subject: Re: mmotm 2013-06-27-16-36 uploaded (wait event common)
Message-ID: <20130630182837.GA5738@redhat.com>
References: <20130627233733.BAEB131C3BE@corp2gmr1-1.hot.corp.google.com> <51CD1F81.4040202@infradead.org> <65029.1372514416@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <65029.1372514416@turing-police.cc.vt.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/29, Valdis.Kletnieks@vt.edu wrote:
>
> On Thu, 27 Jun 2013 22:30:41 -0700, Randy Dunlap said:
>
> > +		__ret = __wait_no_timeout(tout) ?: (tout) ?: 1;
>
> Was this trying to do a  wait_ho_timeout(!!tout)  or something?

No, __wait_no_timeout() means that tout == MAX_SCHEDULE_TIMEOUT.
But the logic is wrong, we should return zero in this case.

Oleg.

