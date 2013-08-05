Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755568Ab3HEXDs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 19:03:48 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59322 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754815Ab3HEXDq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 19:03:46 -0400
Message-ID: <52002F3F.9080407@zytor.com>
Date: Mon, 05 Aug 2013 16:03:27 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: x86@kernel.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 08/16] x86, asmlinkage, kexec: Drop bogus asmlinkage in
 machine_kexec_32
References: <1375740170-7446-1-git-send-email-andi@firstfloor.org> <1375740170-7446-9-git-send-email-andi@firstfloor.org>
In-Reply-To: <1375740170-7446-9-git-send-email-andi@firstfloor.org>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/05/2013 03:02 PM, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 
> A function pointer cannot be asmlinkage. Just drop it.
> 
> Signed-off-by: Andi Kleen <ak@linux.intel.com>

Eh?  It certainly matters for the function pointer if it is regparm(0)
or regparm(3), and the pointed-to function definitely assumes
regparm(0).  So I think this patch is wrong, and if it isn't, it
definitely needs better explanation why it isn't wrong.

	-hpa


