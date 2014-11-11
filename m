Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751855AbaKKSW1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 13:22:27 -0500
Received: from dehamd003.servertools24.de ([31.47.254.18]:34516 "EHLO
	dehamd003.servertools24.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751089AbaKKSW0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 13:22:26 -0500
Message-ID: <546253D2.9050400@ladisch.de>
Date: Tue, 11 Nov 2014 19:22:10 +0100
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64;
	rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Stefan Richter <stefanr@s5r6.in-berlin.de>,
        linux1394-devel@lists.sourceforge.net
CC: linux-api@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Ramos <daramos@stanford.edu>
Subject: Re: [PATCH RFC v1b] firewire: cdev: prevent kernel stack leaking
	into ioctl arguments
References: <55D28623-C1C7-47D2-9638-0B8FD0733C48@stanford.edu>	<20141111010340.3329bbd7@kant>
	<20141111130143.2ff3d42e@kant>	<20141111171356.2fc62440@kant>
	<20141111171644.7f6b17c7@kant>
In-Reply-To: <20141111171644.7f6b17c7@kant>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-PPP-Message-ID: <20141111182104.924270.18534@dehamd003.servertools24.de>
X-PPP-Vhost: ladisch.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Richter wrote:
> This fix simply always null-initializes the entire ioctl argument buffer
> regardless of the actual length of expected user input.  That is, a
> runtime overhead of memset(..., 40) is added to each firewirew-cdev
> ioctl() call.

This part of the stack is most likely to be already in the cache.


Regards,
Clemens
