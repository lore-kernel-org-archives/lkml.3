Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753745AbbANUWo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 15:22:44 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:50050 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752730AbbANUWn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 15:22:43 -0500
To: Sam Bradshaw <sbradshaw@micron.com>
Cc: <martin.petersen@oracle.com>, <axboe@kernel.dk>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] block: pass correct prot_buf pointer to integrity metadata processing function
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <54B6C7E4.6010002@micron.com>
Date: Wed, 14 Jan 2015 15:22:36 -0500
In-Reply-To: <54B6C7E4.6010002@micron.com> (Sam Bradshaw's message of "Wed, 14
	Jan 2015 11:47:48 -0800")
Message-ID: <yq161c9w1rn.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Sam" == Sam Bradshaw <sbradshaw@micron.com> writes:

Hey Sam,

Sam> The prot_buf pointer passed to the generate/verify functions is
Sam> incorrect for the second and subsequent range, making it impossible
Sam> to verify the guard tag.  The patch correctly increments the
Sam> prot_buf pointer by the tuple size for each pass.

prot_buf is just a temporary variable used to get the kernel address of
the buffer pointer. We only care about iter.prot_buf and that gets
incremented by the generate or verify functions.

Are your data buffers page aligned? Things are going to break if they
aren't...

-- 
Martin K. Petersen	Oracle Linux Engineering
