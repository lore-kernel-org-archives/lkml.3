Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756774Ab3FKWPN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 18:15:13 -0400
Received: from plane.gmane.org ([80.91.229.3]:60290 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756481Ab3FKWPK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 18:15:10 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Orion Poplawski <orion@cora.nwra.com>
Subject: Re: Strange intermittent EIO error when writing to stdout since v3.8.0
Date: Tue, 11 Jun 2013 22:14:51 +0000 (UTC)
Message-ID: <loom.20130612T001313-422@post.gmane.org>
References: <20130606115417.GA520@x4> <51B09A26.3080603@hurleysoftware.com> <20130606143750.GB520@x4> <51B1FEB1.8040103@hurleysoftware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: sea.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 4.28.99.98 (Mozilla/5.0 (X11; Linux x86_64; rv:21.0) Gecko/20100101 Firefox/21.0)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Hurley <peter <at> hurleysoftware.com> writes:
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

I get this pretty frequently on my machine with rpmbuild -ba 2>&1 | tee. 
I'd be happy to help to debug.


