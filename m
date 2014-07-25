Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759638AbaGYHia (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 03:38:30 -0400
Received: from ppsw-40.csi.cam.ac.uk ([131.111.8.140]:43273 "EHLO
	ppsw-40.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756732AbaGYHi3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 03:38:29 -0400
X-Greylist: delayed 1398 seconds by postgrey-1.27 at vger.kernel.org; Fri, 25 Jul 2014 03:38:29 EDT
X-Cam-AntiVirus: no malware found
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Subject: Re: linux fsync behaviour
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Content-Type: text/plain; charset=us-ascii
From: Anton Altaparmakov <aia21@cam.ac.uk>
In-Reply-To: <20140725011748.GB26465@dastard>
Date: Fri, 25 Jul 2014 08:15:09 +0100
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <537FA913-E8BF-4B4D-ABC8-F3674B69DDEF@cam.ac.uk>
References: <1406241691732-911707.post@n7.nabble.com> <20140725011748.GB26465@dastard>
To: yuanh <yuanhp_china@hotmail.com>
X-Mailer: Apple Mail (2.1878.6)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 25 Jul 2014, at 02:17, Dave Chinner <david@fromorbit.com> wrote:
> On Thu, Jul 24, 2014 at 03:41:31PM -0700, yuanh wrote:
>> Hi all,
>> 
>>   Two file descriptors are pointing the same file. When fsync is called on
>> one fd, the data written by the other fd will also be flushed? We are using
>> linux XFS.
> 
> Yes.

But beware of the common mistake of using fwrite + fsync which does not actually do what you intend at all and you must instead use fwrite + fflush + fsync...  If you are using write(2) then just fsync is obviously fine.

Best regards,

	Anton
-- 
Anton Altaparmakov <aia21 at cam.ac.uk> (replace at with @)
University of Cambridge Information Services, Roger Needham Building
7 JJ Thomson Avenue, Cambridge, CB3 0RB, UK

