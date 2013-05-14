Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757694Ab3ENOpa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 10:45:30 -0400
Received: from mail-vc0-f176.google.com ([209.85.220.176]:65087 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755913Ab3ENOp3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 10:45:29 -0400
Date: Tue, 14 May 2013 10:45:40 -0400
From: Greg KH <gregkh@linuxfoundation.org>
To: Igor Mammedov <imammedo@redhat.com>
Cc: linux-kernel@vger.kernel.org, konrad.wilk@oracle.com,
        chuck.anderson@oracle.com
Subject: Re: [RFC 0/2] cpu: fix leak and udev race in register_cpu()
Message-ID: <20130514144540.GB14462@kroah.com>
References: <20130513133128.GJ6811@phenom.dumpdata.com>
 <1368482732-25554-1-git-send-email-imammedo@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1368482732-25554-1-git-send-email-imammedo@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 14, 2013 at 12:05:30AM +0200, Igor Mammedov wrote:
> Here is a crude attempt fix race the way suggested by Greg,
> probably done wrong but hopefully in the right direction.
> 
> 1. move "crash_notes" to static attributes to guarantee that it's
> destroyed with CPU on unregister.
> 
> 2. fixes race between hotplugged CPU and onlining it via udev, described here
> https://lkml.org/lkml/2012/4/30/193

Looks right to me, nice job.

greg k-h
