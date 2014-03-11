Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754639AbaCKVaB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 17:30:01 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:60575 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752545AbaCKVaA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 17:30:00 -0400
Date: Tue, 11 Mar 2014 21:29:43 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Tomas Winkler <tomas.winkler@intel.com>
Cc: gregkh@linuxfoundation.org, arnd@arndb.de, linux-kernel@vger.kernel.org,
        Alexander Usyskin <alexander.usyskin@intel.com>
Subject: Re: [char-misc-next 3/3] mei: report consistently copy_from/to_user
 failures
Message-ID: <20140311212943.3d9541f9@alan.etchedpixels.co.uk>
In-Reply-To: <1394542165-19362-3-git-send-email-tomas.winkler@intel.com>
References: <1394542165-19362-1-git-send-email-tomas.winkler@intel.com>
	<1394542165-19362-3-git-send-email-tomas.winkler@intel.com>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Mar 2014 14:49:25 +0200
Tomas Winkler <tomas.winkler@intel.com> wrote:

> From: Alexander Usyskin <alexander.usyskin@intel.com>
> 
> Consistently display error on possible copy_from/to_user failures
> and replace dev_dbg with dev_err

NAK

This allows users to flood the logs by deliberately causing lots of these
failed to copy data error messages, and if they can flood the logs they
can hide other stuff.

The -EFAULT cases should be consistent - but consistently *not* logged.

Alan
