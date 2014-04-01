Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751808AbaDAM4L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 08:56:11 -0400
Received: from mail-oa0-f48.google.com ([209.85.219.48]:54613 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751765AbaDAM4J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 08:56:09 -0400
MIME-Version: 1.0
Date: Tue, 1 Apr 2014 08:56:08 -0400
X-Google-Sender-Auth: nfXZ7QBUMn0XvWJZxhAx_GGmf8M
Message-ID: <CA+5PVA67oBeHUiPXj0viNgrX+uDnJ9LsZSPXF1cLt_D511KKtA@mail.gmail.com>
Subject: liblockdep soname versioning
From: Josh Boyer <jwboyer@fedoraproject.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sasha,

We've had a request [1] to package up liblockdep in Fedora.  Looking
things over, I noticed the library isn't actually versioned at all and
instead just builds a plain .so file.  That's likely fine during
development of it, but if distros are to ship it for broader use then
it would be a good idea to specify the soname and use a versioned .so.

The makefile already has LIBLOCKDEP_VERSION defined.  Would it be
possible to use this as the soname and version number?  Then
liblockdep.so could be the normal symlink to the versioned .so
(liblockdep.so.0.0.1 in this case).

Thanks.

josh

[1] https://bugzilla.redhat.com/show_bug.cgi?id=1082763
