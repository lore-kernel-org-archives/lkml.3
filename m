Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751329AbaDOXei (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 19:34:38 -0400
Received: from imap.thunk.org ([74.207.234.97]:54824 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751208AbaDOXeh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 19:34:37 -0400
Date: Tue, 15 Apr 2014 19:34:35 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Emmanuel Colbus <ecolbus@manux.info>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC][6/11][MANUX] Kernel compatibility : directory hardlinks
Message-ID: <20140415233435.GS4456@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Emmanuel Colbus <ecolbus@manux.info>, linux-kernel@vger.kernel.org
References: <534D3765.4090403@manux.info>
 <20140415200629.GI4456@thunk.org>
 <534D9C44.1050505@manux.info>
 <20140415220119.GM4456@thunk.org>
 <534DBCF5.7070209@manux.info>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <534DBCF5.7070209@manux.info>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 16, 2014 at 01:12:53AM +0200, Emmanuel Colbus wrote:
> The solution is to use directory hardlinks. This way :
>  - applications that want to communicate through /tmp can simply specify
> that they have a dependancy on a package that provides a /tmp directory
> for them; this way, the package manager will create a directory hardlink
> named "/tmp" towards it in their chroot, and they will be able to do
> their thing;
> - as for the cleaning of /tmp, it is done by having all the /tmp
> directories of all the applications hardlinked within the chroot of the
> script tasked with cleaning them.


That's what "bind mounts" in Linux are used for.

If you haven't studied how bind mounts and mount namespaces work in
Linux, I'd strongly encourage that you take a look.  First of all,
it's a much more powerful system, and secondly, that's what most
container based systems are using.

Cheers,

						- Ted
