Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756640Ab3FGSZ2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 14:25:28 -0400
Received: from smtp1.uu.se ([130.238.7.54]:33097 "EHLO smtp1.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756210Ab3FGSZ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 14:25:26 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <20914.9444.867518.719403@pilspetsen.it.uu.se>
Date: Fri, 7 Jun 2013 20:22:28 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Markus Trippelsdorf <markus@trippelsdorf.de>, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Mikael Pettersson <mikpe@it.uu.se>,
        David Howells <dhowells@redhat.com>
Subject: Re: Strange intermittent EIO error when writing to stdout since v3.8.0
In-Reply-To: <51B1FEB1.8040103@hurleysoftware.com>
References: <20130606115417.GA520@x4>
	<51B09A26.3080603@hurleysoftware.com>
	<20130606143750.GB520@x4>
	<51B1FEB1.8040103@hurleysoftware.com>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Hurley writes:
 > Based on the other reports from Mikael and David, I suspect this problem
 > may have to do with my commit 699390354da6c258b65bf8fa79cfd5feaede50b6:
 > 
 >    pty: Ignore slave pty close() if never successfully opened
 > 
 > This commit poisons the pty under certain error conditions that may
 > occur from parallel open()s (or parallel close() with pending write()).
 > 
 > It's unclear to me which error condition is triggered and how user-space
 > got an open file descriptor but that seems the most likely. Is the problem
 > reproducible enough that a debug patch would likely trigger?

In my case the problem occurred frequently enough that I've been forced
to change my build procedures to avoid it.  I'd welcome a debug patch.
