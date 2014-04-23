Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753666AbaDWSHk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 14:07:40 -0400
Received: from merlin.infradead.org ([205.233.59.134]:40023 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750926AbaDWSHi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 14:07:38 -0400
Message-ID: <53580168.3080201@infradead.org>
Date: Wed, 23 Apr 2014 11:07:36 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Masanari Iida <standby24x7@gmail.com>, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH] doc: make clean does not remove some xml files
References: <1398248673-28450-1-git-send-email-standby24x7@gmail.com>
In-Reply-To: <1398248673-28450-1-git-send-email-standby24x7@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/23/14 03:24, Masanari Iida wrote:
> "make clean" does not remove following files in
> Documentations/Docbook.
> 
> audio.h.xml, ca.h.xml, dmx.h.xml, frontend.h.xml
> net.h.xml, videodev2.h.xml vide.h.xml.
> 
> These files are generated when "make xmldocs".
> 
> Signed-off-by: Masanari Iida <standby24x7@gmail.com>

Hi,

The documented way to remove generated doc files is to use
'make cleandocs' (see 'make help').

AFAICT, 'make cleandocs' does remove these generated files.
If not, it would be Good if the generated files list (GENFILES
or MEDIA_TEMP) in Documentation/DocBook/media/Makefile could be used
instead of adding another list of files that might not be updated
when it should be updated.

Thanks.

> ---
>  Documentation/DocBook/Makefile | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/DocBook/Makefile b/Documentation/DocBook/Makefile
> index b444f2e..ec91911 100644
> --- a/Documentation/DocBook/Makefile
> +++ b/Documentation/DocBook/Makefile
> @@ -14,7 +14,9 @@ DOCBOOKS := z8530book.xml device-drivers.xml \
>  	    genericirq.xml s390-drivers.xml uio-howto.xml scsi.xml \
>  	    80211.xml debugobjects.xml sh.xml regulator.xml \
>  	    alsa-driver-api.xml writing-an-alsa-driver.xml \
> -	    tracepoint.xml drm.xml media_api.xml w1.xml
> +	    tracepoint.xml drm.xml media_api.xml w1.xml \
> +	    audio.h.xml ca.h.xml dmx.h.xml frontend.h.xml \
> +	    net.h.xml videodev2.h.xml video.h.xml
>  
>  include Documentation/DocBook/media/Makefile
>  
> 


-- 
~Randy
