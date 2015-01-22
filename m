Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752389AbbAVJ5z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 04:57:55 -0500
Received: from mail-bn1bon0130.outbound.protection.outlook.com ([157.56.111.130]:1776
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750727AbbAVJ5o convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 04:57:44 -0500
From: Dudley Du <dudl@cypress.com>
To: Jeremiah Mahler <jmmahler@gmail.com>
CC: "dmitry.torokhov@gmail.com" <dmitry.torokhov@gmail.com>,
        "rydberg@euromail.se" <rydberg@euromail.se>,
        "bleung@google.com" <bleung@google.com>,
        "dan.carpenter@oracle.com" <dan.carpenter@oracle.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 1/2] input: cyapa: fix sparse warning issue of incorrect
 type in assiggment
Thread-Topic: [PATCH 1/2] input: cyapa: fix sparse warning issue of incorrect
 type in assiggment
Thread-Index: AQHQNg/VldRbzOjyhkSgK7N8HgJIbJzL4EaAgAAElXA=
Date: Thu, 22 Jan 2015 09:57:42 +0000
Message-ID: <BN1PR06MB0701399212A030532981EA8D1490@BN1PR06MB070.namprd06.prod.outlook.com>
References: <1421909406-1240-1-git-send-email-dudl@cypress.com>
 <20150122093129.GA7133@hudson.localdomain>
In-Reply-To: <20150122093129.GA7133@hudson.localdomain>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [140.207.206.26]
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=dudl@cypress.com; 
x-dmarcaction-test: None
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(3005004);SRVR:BN1PR06MB069;
x-exchange-antispam-report-test: UriScan:;
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:;SRVR:BN1PR06MB069;
x-forefront-prvs: 0464DBBBC4
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(51164003)(24454002)(189002)(199003)(51704005)(52604005)(13464003)(110136001)(76176999)(33656002)(2950100001)(76576001)(2900100001)(87936001)(74316001)(2656002)(62966003)(19580395003)(106116001)(50986999)(102836002)(99286002)(77156002)(68736005)(106356001)(54356999)(19580405001)(54606007)(105586002)(66066001)(122556002)(64706001)(40100003)(92566002)(86362001)(97736003)(101416001)(46102003)(54206007)(1411001);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR06MB069;H:BN1PR06MB070.namprd06.prod.outlook.com;FPR:;SPF:None;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: cypress.com
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jan 2015 09:57:42.6159
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 011addfc-2c09-450d-8938-e0bbc2dd2376
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN1PR06MB069
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Jeremiah Mahler [mailto:jmmahler@gmail.com]
> Sent: 2015?1?22? 17:31
> To: Dudley Du
> Cc: dmitry.torokhov@gmail.com; rydberg@euromail.se; bleung@google.com;
> dan.carpenter@oracle.com; linux-input@vger.kernel.org;
> linux-kernel@vger.kernel.org
> Subject: Re: [PATCH 1/2] input: cyapa: fix sparse warning issue of incorrect type in
> assiggment
>
> Dudley,
>
> Mis-spelled 'assiggment' in Subject line.

Thanks for spotting it.

>
> On Thu, Jan 22, 2015 at 02:50:05PM +0800, Dudley Du wrote:
> > Fixes the sparse warning issue of the incorrect type in assignment which
> > found by the kbuild test robot.
> >
> I wasn't able to reproduce the sparse warning.  Was it for a specific
> architecture?  Perhaps include a link to the email sent by the kbuild
> test robot.

Thanks.
The kbuild test robot sends automat email about the warning.
Based on Dimtry's modification and help, I generated the patch.
and tested locally with the command 'make C=1 DF="-D__CHECK_ENDIAN__"',
not issue found currently.

>
> [...]
> >  struct gen5_bl_metadata_row_params {
> >  __le16 size;
> > -__le16 maximun_size;
> > +__le16 maximum_size;
> I don't think sparse cares about variable names.
> Be sure to note these changes in your log.

This is a spell mistake issue, not sparse warning issue.
Thanks.

>
> >  __le32 app_start;
> >  __le16 app_len;
> >  __le16 app_crc;
> > @@ -1192,67 +1192,69 @@ static int cyapa_gen5_bl_enter(struct cyapa
> *cyapa)
> >  static int cyapa_gen5_check_fw(struct cyapa *cyapa, const struct firmware
> *fw)
> >  {
> >  struct device *dev = &cyapa->client->dev;
> > -struct gen5_bl_metadata_row_params metadata;
> > -struct cyapa_tsg_bin_image *image;
> > -int flash_records_count;
> > -u16 app_crc = 0;
> > -u16 app_integrity_crc = 0;
> > -u16 row_num;
> > -u8 *data;
> > +const struct cyapa_tsg_bin_image *image = (const void *)fw->data;
> > +const struct cyapa_tsg_bin_image_data_record *app_integrity;
> > +const struct gen5_bl_metadata_row_params *metadata;
> > +size_t flash_records_count;
> > +u32 fw_app_start, fw_upgrade_start;
> > +u16 fw_app_len, fw_upgrade_len;
> > +u16 app_crc;
> > +u16 app_integrity_crc;
> >  int record_index;
> >  int i;
> >
> > -image = (struct cyapa_tsg_bin_image *)fw->data;
> >  flash_records_count = (fw->size -
> >  sizeof(struct cyapa_tsg_bin_image_head)) /
> >  sizeof(struct cyapa_tsg_bin_image_data_record);
> >
> > -/* APP_INTEGRITY row is always the last row block,
> > - * and the row id must be 0x01ff */
> > -row_num = get_unaligned_be16(
> > -&image->records[flash_records_count - 1].row_number);
> > -if (image->records[flash_records_count - 1].flash_array_id != 0x00 &&
> > -row_num != 0x01ff) {
> > +/*
> > + * APP_INTEGRITY row is always the last row block,
> > + * and the row id must be 0x01ff.
> > + */
> > +app_integrity = &image->records[flash_records_count - 1];
> > +
> > +if (app_integrity->flash_array_id != 0x00 ||
> > +    get_unaligned_be16(&app_integrity->row_number) != 0x01ff) {
> I could be wrong but it looks there are a lot of changes un-related to
> the sparse warning.  I am not opposed to this per se but they should be
> noted in the log message.

Understood.
Indeed, excepted the spell error, the purpose of the changes are aimed to fix the warning issue.
Do I need to add the log message and re-submit the patch or in other method ot change this?
Thanks.

>
> [...]
>
> --
> - Jeremiah Mahler

This message and any attachments may contain Cypress (or its subsidiaries) confidential information. If it has been received in error, please advise the sender and immediately delete this message.
