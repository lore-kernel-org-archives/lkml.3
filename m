Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932714Ab3LEOwP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 09:52:15 -0500
Received: from g1t0026.austin.hp.com ([15.216.28.33]:24147 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751244Ab3LEOwN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 09:52:13 -0500
Message-ID: <1386255131.2802.3.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH] partitions/efi: complete gpt kernel param purpose
From: Davidlohr Bueso <davidlohr@hp.com>
To: Karel Zak <kzak@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Matt Domsch <Matt_Domsch@dell.com>,
        Matt Fleming <matt.fleming@intel.com>,
        "Chandramouleeswaran,Aswin" <aswin@hp.com>
Date: Thu, 05 Dec 2013 06:52:11 -0800
In-Reply-To: <20131205112158.GD8058@x2.net.home>
References: <1386198962.31494.12.camel@buesod1.americas.hpqcorp.net>
	 <20131205112158.GD8058@x2.net.home>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-12-05 at 12:21 +0100, Karel Zak wrote:
> On Wed, Dec 04, 2013 at 03:16:02PM -0800, Davidlohr Bueso wrote:
> > From: Davidlohr Bueso <davidlohr@hp.com>
> > 
> > The usage of the 'gpt' kernel parameter is twofold:
> > (i) skip any mbr integrity checks and (ii) enable the
> > backup GPT header to be used in situations where the
> > primary one is corrupted. This last "feature" is not
> > obvious and needs to be properly documented in the
> > kernel-parameters document.
> 
> The question is if we really have to force users to specify "gpt"
> kernel parameter to use the backup GPT header. Maybe it would be
> enough to report the problem (print warning) and use the valid backup
> header. IMHO the current behaviour is overkill.

Well yes, however, the rationale behind having to use 'gpt' is to
protect against devices which misreport their size, and forces the user
to decide to use the alternate GPT when they still have a valid primary
header. This has been the policy for years.

Thanks,
Davidlohr

