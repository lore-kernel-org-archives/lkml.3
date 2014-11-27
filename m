Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751330AbaK0RCF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 12:02:05 -0500
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.216]:58605 "EHLO
	mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750831AbaK0RCD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 12:02:03 -0500
X-RZG-AUTH: :IW0WYUmmW/LXBXEy1oS2GmByExLj9zw/4tEKkyX4yP6D6vUdA4+4uSj51g==
X-RZG-CLASS-ID: mo00
Date: Thu, 27 Nov 2014 17:55:40 +0100 (CET)
From: Martin Vath <martin@mvath.de>
X-X-Sender: vaeth@biff2
To: Marcin Szychowski <szycha@gmail.com>
cc: Bruno Wolff III <bruno@wolff.to>,
        Phillip Lougher <phillip@squashfs.org.uk>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        texstar@gmail.com, Martin Vaeth <martin@mvath.de>, guanx.bac@gmail.com,
        dave@vasilevsky.ca, blyons@students.naropa.edu, tokiclover@gmail.com,
        afm404@gmail.com, hugochevrain@gmail.com
Subject: Re: [PATCH 0/2] Squashfs: add LZ4 compression
In-Reply-To: <CAJZww4gzTnbyB4jbFQc0N4G6GJ31pVwv-PNZtDMbUxXMoH-orQ@mail.gmail.com>
Message-ID: <alpine.DEB.2.10.1411271716300.17270@biff2>
References: <1417075250-6502-1-git-send-email-phillip@squashfs.org.uk> <20141127133754.GA12750@wolff.to> <CAJZww4gzTnbyB4jbFQc0N4G6GJ31pVwv-PNZtDMbUxXMoH-orQ@mail.gmail.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323329-1311509108-1417106034=:17270"
Content-ID: <alpine.DEB.2.10.1411271734400.17270@biff2>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-1311509108-1417106034=:17270
Content-Type: TEXT/PLAIN; CHARSET=ISO-8859-15; FORMAT=flowed
Content-Transfer-Encoding: 8BIT
Content-ID: <alpine.DEB.2.10.1411271734401.17270@biff2>

Hi:

> squashfs+lz4 / aufs to speed up my laptop

Squashfs proves its usefulness especially in combination
with aufs or overlayfs; I suppose that this combination
will become more popular with the spreading of overlayfs
(e.g. to save disk space etc.)

For users with such a combination, it is especially important
to get a fast (re)compression of huge directories.

The speed of LZ4 for compression in such a setting is really incredible.
Just for orientation for myself, I made a list of times/sizes
on some machines I had access to:

https://github.com/vaeth/squashmount/blob/master/compress.txt

(I do not claim that this is a scientific benchmark - just a
straightforward average over several runs).
The results for the kernel source and libreoffice are really
unbelievable, but I repeated them several times (and,
as you can see, for the kernel sources on different machines).

>From the user perspective, it is mainly important that
the files compressed in this way can be read by the kernel -
the decompression speed is here secondary, so I made no comparison
for this case, although lz4 is known to be very fast also
for decompression.

I would really like to see lz4 support included in the
squashfs kernel driver. I cannot imagine any negative consequences,
especially since squashfs and lz4 are in the kernel, anyway.

Sincerely
Martin Väth
--8323329-1311509108-1417106034=:17270--
