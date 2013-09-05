Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756934Ab3IETDj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 15:03:39 -0400
Received: from imap.thunk.org ([74.207.234.97]:55215 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752581Ab3IETDh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 15:03:37 -0400
Date: Thu, 5 Sep 2013 15:03:34 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Prarit Bhargava <prarit@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] random, Add user configurable get_bytes_random()
Message-ID: <20130905190334.GC23661@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Prarit Bhargava <prarit@redhat.com>, linux-kernel@vger.kernel.org
References: <1378383524-27983-1-git-send-email-prarit@redhat.com>
 <20130905144818.GA23661@thunk.org>
 <52289E6C.8090301@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52289E6C.8090301@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 05, 2013 at 11:08:28AM -0400, Prarit Bhargava wrote:
> 
> The issue isn't userspace /dev/random as much as it is the use of
> get_random_bytes() through out the kernel.  Switching to get_random_bytes_arch()
> is a search'n'replace on the entire kernel.  If a user wants the faster random
> HW generator why shouldn't they be able to use it by default?

Where is the speed of the random number generator a bottleneck?

In general, adding knobs when users can make what might be potentially
the wrong chance is very dangerous.  There is a reason why there
aren't convenient knobs to allow users to select the use of the MD4
checksum, "because it might be faster, why shouldn't the user be
allowed to shoot themselves in the foot"?

					- Ted
