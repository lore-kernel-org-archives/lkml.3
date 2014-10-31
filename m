Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422836AbaJaBj1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 21:39:27 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:52223 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422753AbaJaBj0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 21:39:26 -0400
Date: Fri, 31 Oct 2014 01:39:22 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-api@vger.kernel.org, linux-kernel@vger.kernel.org,
        john.stultz@linaro.org, arnd@arndb.de, tj@kernel.org,
        marcel@holtmann.org, desrt@desrt.ca, hadess@hadess.net,
        dh.herrmann@gmail.com, tixxdz@opendz.org,
        simon.mcvittie@collabora.co.uk, daniel@zonque.org,
        alban.crequy@collabora.co.uk, javier.martinez@collabora.co.uk,
        teg@jklm.no
Subject: Re: kdbus: add code for buses, domains and endpoints
Message-ID: <20141031013922.GG7996@ZenIV.linux.org.uk>
References: <1414620056-6675-1-git-send-email-gregkh@linuxfoundation.org>
 <1414620056-6675-9-git-send-email-gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414620056-6675-9-git-send-email-gregkh@linuxfoundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 29, 2014 at 03:00:52PM -0700, Greg Kroah-Hartman wrote:
> See Documentation/kdbus.txt for more details.

... which has nothing whatsoever on object lifetime rules.  Could you
folks please document that somewhere?  What pins what, what state
transitions are possible, etc.

BTW, the calling conventions for your foo_new() are annoying - instead of
"return -E... or 0, storing the reference to new object in var parameter
passed as the last argument", could you please just return ERR_PTR(-E...)
on error, a pointer to new object on success and to hell with those
struct foo **foo in the argument lists?
