Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755010AbaI2WMA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 18:12:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35775 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754205AbaI2WL7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 18:11:59 -0400
Message-ID: <5429D84B.7080902@redhat.com>
Date: Mon, 29 Sep 2014 18:08:11 -0400
From: David Jeffery <djeffery@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Return short read or 0 at end of a raw device, not EIO
References: <20140929142110.GA12562@fury.redhat.com> <20140929190509.GA2767@infradead.org>
In-Reply-To: <20140929190509.GA2767@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/29/2014 03:05 PM, Christoph Hellwig wrote:
> Seems like this should be changed in the generic code, or is there some
> reason why it would return EIO only for devices, but not for regular
> files in this case?
> 

Regular files shouldn't be returning EIO and don't in my tests. The file
systems manage direct I/O EOF handling in their own block or direct_IO
callbacks.  Block devices do not and instead do the size checks up
front.  Raw devices were bypassing the block device check, so only the
raw driver should be having this issue.

David Jeffery
