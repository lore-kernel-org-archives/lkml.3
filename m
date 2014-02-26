Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752317AbaBZCwZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 21:52:25 -0500
Received: from mail-ie0-f181.google.com ([209.85.223.181]:43577 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751062AbaBZCwX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 21:52:23 -0500
Date: Tue, 25 Feb 2014 18:52:19 -0800
From: Brian Norris <computersforpeace@gmail.com>
To: Kamlakant Patel <kamlakant.patel@broadcom.com>
Cc: linux-mtd@lists.infradead.org, Jayachandran C <jchandra@broadcom.com>,
        dwmw2@infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] jffs2: Fix segmentation fault found in stress test
Message-ID: <20140226025219.GF4194@ld-irv-0074>
References: <1389015415-25196-1-git-send-email-kamlakant.patel@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389015415-25196-1-git-send-email-kamlakant.patel@broadcom.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 06, 2014 at 07:06:54PM +0530, Kamlakant Patel wrote:
> Creating a large file on a JFFS2 partition sometimes crashes with this call
> trace:
[...]
> 
> This crash is caused because the 'positions' is declared as an array of signed
> short. The value of position is in the range 0..65535, and will be converted
> to a negative number when the position is greater than 32767 and causes a
> corruption and crash. Changing the definition to 'unsigned short' fixes this
> issue
> 
> Signed-off-by: Jayachandran C <jchandra@broadcom.com>
> Signed-off-by: Kamlakant Patel <kamlakant.patel@broadcom.com>

Pushed both patches to l2-mtd.git, and tagged them for -stable. Let me
know if you object.

Thanks,
Brian
