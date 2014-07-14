Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756227AbaGNQKZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 12:10:25 -0400
Received: from mail-qa0-f45.google.com ([209.85.216.45]:33891 "EHLO
	mail-qa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755615AbaGNQKP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 12:10:15 -0400
Date: Mon, 14 Jul 2014 12:10:10 -0400
From: Tejun Heo <tj@kernel.org>
To: Alexey Asemov <alex@alex-at.ru>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] libata: handle IDE AMNF errors in the EH path
Message-ID: <20140714161010.GE31610@htj.dyndns.org>
References: <1405153373-11108-1-git-send-email-alex@alex-at.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405153373-11108-1-git-send-email-alex@alex-at.ru>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 12, 2014 at 12:22:53PM +0400, Alexey Asemov wrote:
> libata-eh.c should handle AMNF error condition (error byte bit 0, usually
> code 0x01) in libata-eh.c along with UNC as a media error so SCSI stack
> can handle it properly (translation code 0x01 is already present in
> libata-scsi.c) but was never passed down due to lack of handling in EH.

IIRC AMNF has been deprecated for a very long time now.  The bit isn't
too likely to get reused given that major updates to ATA spec is
improbable but I'm still not quite fond of adding handling of a long
deprecated flag.  Can you please provide a bit more detail?  Which
device was it?

Thanks.

-- 
tejun
