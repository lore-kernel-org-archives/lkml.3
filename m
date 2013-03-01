Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754749Ab3CACyO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 21:54:14 -0500
Received: from mail-pb0-f42.google.com ([209.85.160.42]:33379 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751737Ab3CACyM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 21:54:12 -0500
MIME-Version: 1.0
In-Reply-To: <20130228161151.0fbbff98@corrin.poochiereds.net>
References: <1361831310-24260-1-git-send-email-chiluk@canonical.com>
	<512DE8A6.9030000@samba.org>
	<20130227083419.0af9deaf@corrin.poochiereds.net>
	<512E8787.6070709@canonical.com>
	<20130228072637.3b71a4f7@corrin.poochiereds.net>
	<E1UBCMh-00FRaK-CC@intern.SerNet.DE>
	<20130228161151.0fbbff98@corrin.poochiereds.net>
Date: Thu, 28 Feb 2013 20:54:12 -0600
Message-ID: <CAH2r5ms_xdRBUnMknL0NnmpQZq11Uyvx1MaMcpjkL3JTm1CqfA@mail.gmail.com>
Subject: Re: [PATCH] CIFS: Decrease reconnection delay when switching nics
From: Steve French <smfrench@gmail.com>
To: Jeff Layton <jlayton@samba.org>
Cc: =?ISO-8859-1?Q?Bj=F6rn_JACKE?= <bj@sernet.de>,
        Dave Chiluk <dave.chiluk@canonical.com>,
        Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org,
        "Stefan (metze) Metzmacher" <metze@samba.org>,
        Dave Chiluk <chiluk@canonical.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 28, 2013 at 6:11 PM, Jeff Layton <jlayton@samba.org> wrote:
> On Thu, 28 Feb 2013 23:54:13 +0100
> Björn JACKE <bj@SerNet.DE> wrote:
>
>> On 2013-02-28 at 07:26 -0800 Jeff Layton sent off:
>> > NTFS doesn't support sparse files, so the OS has to zero-fill up to the
>> > point where you're writing. That can take a looooong time on slow
>> > storage (minutes even).
>>
>> but you are talking about FAT here, right? NTFS does support sparse files if
>> the sparse bit has been explicitly been set on it. Bit even if the sparse bit
>> is not set filling a file with zeros by writing after a seek long beyond the
>> end of the file is very fast because NTFS supports that feature what Unix
>> filesystems like xfs call extents.
>>
>> If writing beyond the end of a file is really slow via cifs vfs in the test
>> case against a ntfs volume then I wonder if that operation is being really done
>> optimally over the wire. ntfs really isn't that bad with handling this kind of
>> files.
>>
>
> I'm not sure since I don't know the internals of NTFS. I had always
> assumed that it didn't really handle sparse files well (hence the
> "rabbit-pellet" thing that windows clients do).
>
> All I can say however is that writes long past the EOF can take a
> *really* long time to run. Typically we just issue a SMB_COM_WRITEX at
> the offset to which we want to put the data. Is there some other way we
> ought to be doing this?
>
> In any case, it doesn't really change the fact that there is no
> guaranteed time of response from CIFS servers. They can easily take a
> really long time to respond to certain requests. The best method we
> have to deal with that is to periodically "ping" the server with an
> echo to see if it's still there.

SMB2/SMB3 with better async support may make this easier - but Jeff is right.

-- 
Thanks,

Steve
