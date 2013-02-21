Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753392Ab3BUNTh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 08:19:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:18754 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752805Ab3BUNTg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 08:19:36 -0500
Date: Thu, 21 Feb 2013 13:19:31 +0000
From: Alasdair G Kergon <agk@redhat.com>
To: Tim Gardner <tim.gardner@canonical.com>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
        dm-devel@redhat.com, Alasdair Kergon <agk@redhat.com>
Subject: Re: [dm-devel] [PATCH linux-next] DM RAID:
	validate_raid_redundancy: Silence uninitialized variable warning
Message-ID: <20130221131931.GA29577@agk-dp.fab.redhat.com>
Mail-Followup-To: Tim Gardner <tim.gardner@canonical.com>,
	linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
	dm-devel@redhat.com, Alasdair Kergon <agk@redhat.com>
References: <1361392278-59767-1-git-send-email-tim.gardner@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1361392278-59767-1-git-send-email-tim.gardner@canonical.com>
Organization: Red Hat UK Ltd. Registered in England and Wales, number
	03798903. Registered Office: 64 Baker Street, 4th floor, London,
	W1U 7DF.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 20, 2013 at 01:31:18PM -0700, Tim Gardner wrote:
> drivers/md/dm-raid.c: In function 'raid_ctr':
> drivers/md/dm-raid.c:453:53: warning: 'rebuilds_per_group' may be used uninitialized in this function [-Wuninitialized]
> drivers/md/dm-raid.c:383:11: note: 'rebuilds_per_group' was declared here
 
> It appears unlikely that rebuilds_per_group could be used before set, but set
> it to 0 anyways just to shutup GCC.

Looks bogus to me.
uninitialized_var() please.

Alasdair

