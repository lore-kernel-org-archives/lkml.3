Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757819Ab3EKAOl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 20:14:41 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:37676 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756426Ab3EKAOj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 20:14:39 -0400
Date: Sat, 11 May 2013 01:14:32 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>, Andreas Dilger <adilger@dilger.ca>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        linux-ext4 <linux-ext4@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] jbd2: Fix block tag checksum verification brokenness
Message-ID: <20130511001432.GO25399@ZenIV.linux.org.uk>
References: <20130510233807.GB5706@blackbox.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130510233807.GB5706@blackbox.djwong.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 10, 2013 at 04:38:07PM -0700, Darrick J. Wong wrote:
> Al Viro complained of a ton of bogosity with regards to the jbd2 block tag
> header checksum.  This one checksum is 16 bits, so cut off the upper 16 bits
> and treat it as a 16-bit value and don't mess around with be32* conversions.
> Fortunately metadata checksumming is still "experimental" and not in a shipping
> e2fsprogs, so there should be few users affected by this.
> 
> v2: Eliminate unnecessary variables and make it clear(er) which values are 32
> bits wide.
> 
> Reported-by: Al Viro <viro@ZenIV.linux.org.uk>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

ACKed-by: Al Viro <viro@ZenIV.linux.org.uk>
