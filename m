Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756593Ab3LaUGl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Dec 2013 15:06:41 -0500
Received: from mailuogwhop.emc.com ([168.159.213.141]:23798 "EHLO
	mailuogwhop.emc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755088Ab3LaUGh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Dec 2013 15:06:37 -0500
X-Greylist: delayed 1446 seconds by postgrey-1.27 at vger.kernel.org; Tue, 31 Dec 2013 15:06:37 EST
X-DKIM: OpenDKIM Filter v2.4.3 mailuogwprd03.lss.emc.com rBVJfrLO021828
X-DKIM: OpenDKIM Filter v2.4.3 mailuogwprd03.lss.emc.com rBVJfrLO021828
From: "berthiaume, wayne" <wayne.berthiaume@emc.com>
To: "Martin K. Petersen" <mkp@mkp.net>
CC: Jens Axboe <axboe@kernel.dk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Date: Tue, 31 Dec 2013 14:41:35 -0500
Subject: RE: status of block-integrity
Thread-Topic: status of block-integrity
Thread-Index: Ac7/6BtNUuqhipU5TgGxPjh53rlTdAGd3/tQ
Message-ID: <7B999F046DA9D54B825BD537939A3E2F023284EC69@MX23A.corp.emc.com>
References: <20131222192128.GA28532@infradead.org>
 <yq11u134rmt.fsf@sermon.lab.mkp.net>
In-Reply-To: <yq11u134rmt.fsf@sermon.lab.mkp.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Sentrion-Hostname: mailusrhubprd52.lss.emc.com
X-RSA-Classifications: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

You can add there are SCSI targets out there employing this feature as well. =;^)

-----Original Message-----
From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Martin K. Petersen
Sent: Monday, December 23, 2013 8:35 AM
To: Christoph Hellwig
Cc: Jens Axboe; linux-kernel@vger.kernel.org; linux-scsi@vger.kernel.org
Subject: Re: status of block-integrity

>>>>> "Christoph" == Christoph Hellwig <hch@infradead.org> writes:

Christoph> We have the block integrity code to support DIF/DIX in the 
Christoph> the tree for about 5 and a half years, and we still don't 
Christoph> have a single consumer of it.

What do you mean? If you have a DIX-capable HBA (lpfc, qla2xxx, zfcp) then integrity protection is active from the block layer down. The only code that's not currently being exercised are the tag interleaving functions.  I was hoping the FS people would use them for back pointers but nobody seemed to bite.


Christoph> Given that we'll have a lot of work to do in this area with 
Christoph> block multiqueue I think it's time to either kill it off for 
Christoph> good or make sure we can actually use and test it.

I don't understand why multiqueue would require a lot of work? It's just an extra scatterlist per request.

And obviously, if there's anything that needs to be done in this area I'll be happy to do so...

-- 
Martin K. Petersen	Oracle Linux Engineering

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in the body of a message to majordomo@vger.kernel.org More majordomo info at  http://vger.kernel.org/majordomo-info.html

