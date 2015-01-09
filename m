Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758267AbbAIWvz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 17:51:55 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:37881 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758167AbbAIWvy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 17:51:54 -0500
Date: Fri, 9 Jan 2015 14:51:53 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Tomas Winkler <tomas.winkler@intel.com>
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org
Subject: Re: [char-misc-next 3/3 V2] mei: add reference counting for me
 clients
Message-ID: <20150109225153.GA20890@kroah.com>
References: <1417090049-23219-1-git-send-email-tomas.winkler@intel.com>
 <1417090049-23219-3-git-send-email-tomas.winkler@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1417090049-23219-3-git-send-email-tomas.winkler@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 27, 2014 at 02:07:29PM +0200, Tomas Winkler wrote:
> To support dynamic addition and removal of
> me clients we add reference counter.
> 
> Update kdoc with locking requirements.
> 
> Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>

This patch adds build warnings, I can't take it:

drivers/misc/mei/bus.c: In function ‘___mei_cl_send’:
drivers/misc/mei/bus.c:276:3: warning: ‘cb’ may be used uninitialized in this function [-Wmaybe-uninitialized]
   mei_io_cb_free(cb);
   ^
drivers/misc/mei/bus.c:273:2: warning: ‘me_cl’ may be used uninitialized in this function [-Wmaybe-uninitialized]
  mei_me_cl_put(me_cl);
  ^

Please be more careful.
