Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752680Ab3F0Lue (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 07:50:34 -0400
Received: from mail-by2lp0243.outbound.protection.outlook.com ([207.46.163.243]:32630
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752204Ab3F0Lua (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 07:50:30 -0400
X-Forefront-Antispam-Report-Untrusted: CIP:157.56.240.21;KIP:(null);UIP:(null);(null);H:BL2PRD0310HT001.namprd03.prod.outlook.com;R:internal;EFV:INT
X-SpamScore: -3
X-BigFish: PS-3(zz98dI9371Ic89bh936eI542I1432Izz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzz8275dhz31h2a8h668h839h93fhd24hf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h19ceh1ad9h1b0ah1d07h1d0ch1d2eh1d3fh1de9h1dfeh1dffh1e1dh9a9j1155h)
X-Forefront-Antispam-Report-Untrusted: SFV:NSPM;SFS:(189002)(199002)(13464003)(51704005)(377424004)(377454003)(24454002)(74366001)(56816003)(16406001)(74502001)(47446002)(74706001)(81342001)(77096001)(81542001)(74316001)(74662001)(76786001)(76796001)(31966008)(79102001)(76576001)(33646001)(65816001)(76482001)(74876001)(69226001)(4396001)(54356001)(50986001)(80022001)(59766001)(54316002)(53806001)(77982001)(47736001)(49866001)(47976001)(66066001)(46102001)(51856001)(63696002)(56776001)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:SN2PR03MB064;H:SN2PR03MB061.namprd03.prod.outlook.com;RD:InfoNoRecords;MX:1;A:1;LANG:en;
From: KY Srinivasan <kys@microsoft.com>
To: James Bottomley <jbottomley@parallels.com>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "ohering@suse.com" <ohering@suse.com>,
        "hch@infradead.org" <hch@infradead.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: RE: [PATCH 3/5] Drivers: scsi: storvsc: Implement multi-channel
 support
Thread-Topic: [PATCH 3/5] Drivers: scsi: storvsc: Implement multi-channel
 support
Thread-Index: AQHOYVG/XcCyfQUdNUepLvaiM3eXU5lJCHOAgACGtoA=
Date: Thu, 27 Jun 2013 11:50:05 +0000
Message-ID: <f2d5a6702ab042f0adc09378cd68cf31@SN2PR03MB061.namprd03.prod.outlook.com>
References: <1370372674-10046-1-git-send-email-kys@microsoft.com>
	 <1370372709-10098-1-git-send-email-kys@microsoft.com>
	 <1370372709-10098-3-git-send-email-kys@microsoft.com>
 <1372303344.557.6.camel@dabdike>
In-Reply-To: <1372303344.557.6.camel@dabdike>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [98.110.61.163]
x-forefront-prvs: 08902E536D
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OrganizationHeadersPreserved: SN2PR03MB064.namprd03.prod.outlook.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%SUSE.COM$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%INFRADEAD.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%VGER.KERNEL.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXDRIVERPROJECT.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%PARALLELS.COM$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXFOUNDATION.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-CrossPremisesHeadersPromoted: TK5EX14HUBC105.redmond.corp.microsoft.com
X-CrossPremisesHeadersFiltered: TK5EX14HUBC105.redmond.corp.microsoft.com
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(189002)(199002)(51704005)(13464003)(377424004)(24454002)(377454003)(46102001)(76796001)(77982001)(74316001)(31966008)(74366001)(16676001)(50466002)(44976004)(81542001)(59766001)(79102001)(65816001)(76576001)(33646001)(54356001)(54316002)(47446002)(6806003)(77096001)(51856001)(76786001)(56776001)(53806001)(81342001)(74662001)(56816003)(47736001)(74706001)(47776003)(63696002)(66066001)(76482001)(23676002)(80022001)(49866001)(4396001)(69226001)(74502001)(74876001)(47976001)(50986001)(20776003)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BY2FFO11HUB015;H:TK5EX14HUBC105.redmond.corp.microsoft.com;CLIP:131.107.125.37;RD:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-OriginatorOrg: microsoft.onmicrosoft.com
X-O365ENT-EOP-Header: Message processed by -  O365_ENT: Allow from ranges
 (Engineering ONLY)
X-Forefront-PRVS: 08902E536D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r5RBojq6013602



> -----Original Message-----
> From: James Bottomley [mailto:jbottomley@parallels.com]
> Sent: Wednesday, June 26, 2013 11:22 PM
> To: KY Srinivasan
> Cc: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; ohering@suse.com; hch@infradead.org; linux-
> scsi@vger.kernel.org
> Subject: Re: [PATCH 3/5] Drivers: scsi: storvsc: Implement multi-channel support
> 
> On Tue, 2013-06-04 at 12:05 -0700, K. Y. Srinivasan wrote:
> > Implement multi-channel support for the storage devices.
> 
> This doesn't compile:
> 
>   CC [M]  drivers/scsi/storvsc_drv.o
> drivers/scsi/storvsc_drv.c: In function ‚Äòhandle_sc_creation‚Äô:
> drivers/scsi/storvsc_drv.c:763:35: error: ‚Äòstruct vmbus_channel‚Äô has no
> member named ‚Äòprimary_channel‚Äô
> drivers/scsi/storvsc_drv.c: In function ‚Äòhandle_multichannel_storage‚Äô:
> drivers/scsi/storvsc_drv.c:805:2: error: implicit declaration of
> function
> ‚Äòvmbus_set_sc_create_callback‚Äô [-Werror=implicit-function-declaration]
> drivers/scsi/storvsc_drv.c:812:2: error: implicit declaration of
> function
> ‚Äòvmbus_are_subchannels_present‚Äô [-Werror=implicit-function-declaration]
> drivers/scsi/storvsc_drv.c: In function ‚Äòstorvsc_on_channel_callback‚Äô:
> drivers/scsi/storvsc_drv.c:1223:13: error: ‚Äòstruct vmbus_channel‚Äô has no
> member named ‚Äòprimary_channel‚Äô
> drivers/scsi/storvsc_drv.c:1224:19: error: ‚Äòstruct vmbus_channel‚Äô has no
> member named ‚Äòprimary_channel‚Äô
> drivers/scsi/storvsc_drv.c: In function ‚Äòstorvsc_do_io‚Äô:
> drivers/scsi/storvsc_drv.c:1341:2: error: implicit declaration of
> function
> ‚Äòvmbus_get_outgoing_channel‚Äô [-Werror=implicit-function-declaration]
> drivers/scsi/storvsc_drv.c:1341:19: warning: assignment makes pointer
> from integer without a cast [enabled by default]
> cc1: some warnings being treated as errors
> make[2]: *** [drivers/scsi/storvsc_drv.o] Error 1
> 
> I assume this is a cross tree dependency?  What's the relevant branch I
> need?

You are right; Greg checked in the relevant patch sometime back:

git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-next branch.


Regards,

K. Y

> 
> James

ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
