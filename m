Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753205Ab3GXWSF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 18:18:05 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55622 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752153Ab3GXWSD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 18:18:03 -0400
Date: Wed, 24 Jul 2013 15:18:02 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Dean Jenkins <Dean_Jenkins@mentor.com>
Cc: Andre Naujoks <nautsch2@gmail.com>, linux-kernel@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>
Subject: Re: [PATCH 2/5] SLIP: Handle error codes from the TTY layer
Message-ID: <20130724221802.GB21709@kroah.com>
References: <1372779094-11730-1-git-send-email-Dean_Jenkins@mentor.com>
 <1372779094-11730-3-git-send-email-Dean_Jenkins@mentor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1372779094-11730-3-git-send-email-Dean_Jenkins@mentor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 02, 2013 at 04:31:31PM +0100, Dean Jenkins wrote:
> It appears that SLIP does not handle error codes from the TTY layer.
> This will result in a malfunction because the remaining length of
> data will be corrupted by the negative error code values from the TTY
> layer.
> 
> Therefore, add error code checks in sl_encaps() and sl_encaps_wakeup()
> to prevent the corruption of the sent data length.
> 
> Note that SLIP is connectionless so on TTY error indicate that all data
> was sent. It seems SLIP does not return error codes to the network
> layer.
> 
> Signed-off-by: Dean Jenkins <Dean_Jenkins@mentor.com>

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
