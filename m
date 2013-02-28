Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756099Ab3B1XC4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 18:02:56 -0500
Received: from mail1.SerNet.de ([193.175.80.2]:50201 "EHLO mail.SerNet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755748Ab3B1XCu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 18:02:50 -0500
X-Greylist: delayed 512 seconds by postgrey-1.27 at vger.kernel.org; Thu, 28 Feb 2013 18:02:50 EST
Date: Thu, 28 Feb 2013 23:54:13 +0100
From: =?iso-8859-1?Q?Bj=F6rn?= JACKE <bj@SerNet.DE>
To: Jeff Layton <jlayton@samba.org>
Cc: Dave Chiluk <dave.chiluk@canonical.com>, Steve French <sfrench@samba.org>,
        linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        linux-kernel@vger.kernel.org,
        "Stefan (metze) Metzmacher" <metze@samba.org>,
        Dave Chiluk <chiluk@canonical.com>
Subject: Re: [PATCH] CIFS: Decrease reconnection delay when switching nics
Mail-Followup-To: Jeff Layton <jlayton@samba.org>,
	Dave Chiluk <dave.chiluk@canonical.com>,
	Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org, linux-kernel@vger.kernel.org,
	"Stefan (metze) Metzmacher" <metze@samba.org>,
	Dave Chiluk <chiluk@canonical.com>
References: <1361831310-24260-1-git-send-email-chiluk@canonical.com>
 <512DE8A6.9030000@samba.org>
 <20130227083419.0af9deaf@corrin.poochiereds.net>
 <512E8787.6070709@canonical.com>
 <20130228072637.3b71a4f7@corrin.poochiereds.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130228072637.3b71a4f7@corrin.poochiereds.net>
X-Q: Die Schriftsteller koennen nicht so schnell schreiben, wie die
 Regierungen Kriege machen; denn das Schreiben verlangt Denkarbeit. - Brecht
Message-Id: <E1UBCMh-00FRaK-CC@intern.SerNet.DE>
Organization: SerNet GmbH, Goettingen, Germany
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013-02-28 at 07:26 -0800 Jeff Layton sent off:
> NTFS doesn't support sparse files, so the OS has to zero-fill up to the
> point where you're writing. That can take a looooong time on slow
> storage (minutes even).

but you are talking about FAT here, right? NTFS does support sparse files if
the sparse bit has been explicitly been set on it. Bit even if the sparse bit
is not set filling a file with zeros by writing after a seek long beyond the
end of the file is very fast because NTFS supports that feature what Unix
filesystems like xfs call extents.

If writing beyond the end of a file is really slow via cifs vfs in the test
case against a ntfs volume then I wonder if that operation is being really done
optimally over the wire. ntfs really isn't that bad with handling this kind of
files.

Cheers
Björn
