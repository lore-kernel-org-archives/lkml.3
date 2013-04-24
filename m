Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932415Ab3DXLAx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 07:00:53 -0400
Received: from smtp.nue.novell.com ([195.135.221.5]:60807 "EHLO
	smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932172Ab3DXLAv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 07:00:51 -0400
Subject: Re: [PATCH V6 3/3] efi: Distinguish between "remaining space" and
 actually used space
From: joeyli <jlee@suse.com>
To: Matthew Garrett <matthew.garrett@nebula.com>
Cc: "matt.fleming@intel.com" <matt.fleming@intel.com>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <1366798497.13667.25.camel@x230.lan>
References: <1365561717-12343-1-git-send-email-matthew.garrett@nebula.com>
	 <1366056587-24414-1-git-send-email-matthew.garrett@nebula.com>
	 <1366056587-24414-4-git-send-email-matthew.garrett@nebula.com>
	 <1366798111.23707.293.camel@linux-s257.site>
	 <1366798497.13667.25.camel@x230.lan>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 24 Apr 2013 18:59:33 +0800
Message-ID: <1366801173.23707.323.camel@linux-s257.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

於 三，2013-04-24 於 10:14 +0000，Matthew Garrett 提到：
> On Wed, 2013-04-24 at 18:08 +0800, joeyli wrote:
> 
> > It causes the garbage size increased and remaining_size decreased. But
> > we still can create new variable because active_size doesn't increase
> > due to we delete variable before create new. So, the condition
> > "remaining_size - size < storage_size / 2" will not really hit because
> > active_size condition is pass.
> 
> That's fine - the (limited) information we have from Samsung is that
> there's no problem if all the space is dirty, only if all the space is
> marked as active.
> 
> -- 
> Matthew Garrett | mjg59@srcf.ucam.org

Got it! Thanks for your explanation!

Then why we don't just remove the "remaining_size" condition but only
monitor the active_size should not larger then 1/2 storage_size?

Does that because we allow one and only one VAR_METADATA_SIZE beyond the
1/2 storage? If so, why we don't just give ( 1/2 storage_size +
VAR_METADATA_SIZ) space for active_size using?


Thanks a lot!
Joey Lee


